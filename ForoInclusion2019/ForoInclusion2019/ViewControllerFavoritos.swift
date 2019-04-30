//
//  ViewControllerFavoritos.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class ViewControllerFavoritos: UIViewController, UITableViewDataSource, UITableViewDelegate, cambiaFavorito {

    @IBOutlet weak var tablaEventos: UITableView!
    @IBOutlet weak var dias_filtro: UISegmentedControl!
    var filtroAmbito = Ambito.allCases
    var filtroTipo = TipoDiscapacidad.allCases
    
    var cellHeight : CGFloat = 30
    
    var favoritos: [Evento]!
    var delegado: cambiaFavorito!
    var dia: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dia = 0
        calculateDays()
        filtra(day: dia)
    }
    
    func filtra(day: Int){
        var eventosFiltrados = [Evento]()
        for evento in favoritos {
            for ambito in evento.ambitos {
                if filtroAmbito.contains(ambito) {
                    eventosFiltrados.append(evento)
                    break
                }
            }
            for tipo in evento.tiposDiscapacidad {
                if filtroTipo.contains(tipo) {
                    eventosFiltrados.append(evento)
                    break
                }
            }
        }
        var Aux = [Evento]()
        for evento in favoritos {
            if evento.dia == dia {
                Aux.append(evento)
            }
        }
        eventosFiltrados = Aux
        tablaEventos.reloadData()
    }
    
    //Alguien debería refactorear esto ;D
    func getNumberMonth(Month: String)->Int{
        /*
         Enero, feb, marzo, abril, mayo, junio, julio, agosto, septiembre, octubre, noviembre, diciembre
         */
        let mm = Month.lowercased()
        switch mm {
        case "enero":
            return 1
        case "febrero":
            return 2
        case "marzo":
            return 3
        case "abril":
            return 4
        case "mayo":
            return 5
        case "junio":
            return 6
        case "julio":
            return 7
        case "agosto":
            return 8
        case "septiembre":
            return 9
        case "octubre":
            return 10
        case "noviembre":
            return 11
        case "diciembre":
            return 12
        default:
            //???
            //Enero I guess
            return 1
        }
    }
  
    
    func calculateDays(){
        //calculate day for all events
        
        
        var allFechas = [Date]()
        
        
        let formater = DateFormatter()
        //2019-04-26
        formater.dateFormat = "yyyy/MM/dd"
        for ev in favoritos {
            allFechas.append(formater.date(from: getDate(ev: ev))!)
        }
        
        allFechas.sort()
        
        //Remove duplicates
        var idx = 0
        let n = allFechas.count
        var auxFechas = [Date]()
        while(idx < n){
            if(idx+1 < n && allFechas[idx+1] == allFechas[idx]){
                idx+=1
            }
            auxFechas.append(allFechas[idx])
            idx+=1
        }
        
        allFechas = auxFechas
        for ev in favoritos{
            if ev.dia == -1 {
                for i in 0..<allFechas.count{
                    if formater.date(from: getDate(ev: ev)) == allFechas[i] {
                        ev.dia = i
                        break;
                    }
                }
            }
        }
        
    }
    
    func getDate(ev: Evento)->String{
        
        var fecha =  ev.fecha.split{$0 == " "}.map(String.init)
        var currentDate = String(getNumberMonth(Month: fecha[2]))
        currentDate+="/"+fecha[0]+"/"
        currentDate += String(Calendar.current.component(.year, from: Date()))
        
        return currentDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tablaEventos.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(favoritos)
        return favoritos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight * 10.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaEvento", for: indexPath) as! TableViewCellEvento
        let evento = favoritos[indexPath.row]
        
        cell.load(evento: evento, delegado: self, isFavorito: true)
        
        // getSize of title and update global cellHeight var
        cellHeight = cell.getFontSize()
        
        return cell
    }
    
    // MARK: - Protocol cambiaFavorito
    
    func agregaFavorito(evento: Evento) {
    }
    @IBAction func filtroDia(_ sender: UISegmentedControl) {
        dia = sender.selectedSegmentIndex
        filtra(day: dia)
    }
    
    func eliminaFavorito(evento: Evento) {
        delegado.eliminaFavorito(evento: evento)
        favoritos.remove(at: favoritos.firstIndex(of: evento)!)
        // TODO: Esta animación no muestra nada, buscar si se puede animar.
        UIView.animate(withDuration: 1) {
            self.tablaEventos.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! TableViewCellEvento
        let vistaDetalle = segue.destination as! ViewControllerDetalleEvento
        vistaDetalle.cellEvento = cell
        vistaDetalle.favSelected = !cell.favSelected
    }

}
