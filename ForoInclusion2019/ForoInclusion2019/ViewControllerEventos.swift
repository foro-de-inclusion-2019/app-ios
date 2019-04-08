//
//  ViewControllerEventos.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class ViewControllerEventos: UIViewController, UITableViewDataSource, UITableViewDelegate, actualizaFiltros, cambiaFavorito {
    
    @IBOutlet weak var tablaEventos: UITableView!
    @IBOutlet weak var dias_filtro: UISegmentedControl!
    
    var filtroAmbito = Ambito.allCases
    var filtroTipo = TipoDiscapacidad.allCases
    
    var eventos = [Evento]()
    var favoritos = [Evento]()
    var eventosFiltrados = [Evento]()
    var isfav: Bool!
    //Dia a filtrar
    var dia: Int!
    
    var cellHeight : CGFloat = 30
    
    var delegado: cambiaFavorito!
    
    
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
    
    func getDate(ev: Evento)->String{
        
        var fecha =  ev.fecha.split{$0 == " "}.map(String.init)
        var currentDate = String(getNumberMonth(Month: fecha[2]))
        currentDate+="/"+fecha[0]+"/"
        currentDate += String(Calendar.current.component(.year, from: Date()))
        
        return currentDate
    }
    
    func calculateDays(){
        //calculate day for all events

        
        var allFechas = [Date]()
        
        
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        for ev in eventos {
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
        for ev in eventos{
            if ev.Dia == -1 {
                for i in 0..<allFechas.count{
                    if formater.date(from: getDate(ev: ev)) == allFechas[i] {
                        ev.Dia = i
                        break;
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dia = 0
        
        
        if isfav {
//            //Traer favoritos desde el document
//            let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//            let archiveURL = documentsDirectory.appendingPathComponent("Favoritos")
//
//            do{
//                let data = try Data.init(contentsOf: archiveURL)
//                let empTmp = try
//                    PropertyListDecoder().decode([Evento].self, from: data)
//
//            }catch {
//                
//            }
        }
        
        
        calculateDays()
        filtrar(day: dia)
        
    }
        //Empiezan en el evento 0 (Dia 1)
    

    override func viewWillAppear(_ animated: Bool) {
        tablaEventos.reloadData()
    }
    
    func filtrar(day: Int) {
        eventosFiltrados = [Evento]()
        for evento in eventos {
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
        for evento in eventosFiltrados {
            if evento.Dia == dia{
                Aux.append(evento)
            }
        }
        eventosFiltrados = Aux
        tablaEventos.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight * 10.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaEvento", for: indexPath) as! TableViewCellEvento
        let evento = eventosFiltrados[indexPath.row]
        let isFavorito = favoritos.contains(evento)
        
        cell.load(evento: evento, delegado: self, isFavorito: isFavorito)
        
        // getSize of title and update global cellHeight var
        cellHeight = cell.getFontSize()
        
        return cell
    }
    
    // Mark: - Protocol actualizaFiltros
    
    func actualizarFiltros(ambitos: [Ambito], tipos: [TipoDiscapacidad]) {
        filtroAmbito = ambitos
        filtroTipo = tipos
        filtrar(day: dia)
        tablaEventos.reloadData()
    }
    
    // MARK: - Protocol cambiaFavorito
    
    func agregaFavorito(evento: Evento) {
        delegado.agregaFavorito(evento: evento)
        favoritos.append(evento)
        UIView.animate(withDuration: 1) {
            self.tablaEventos.reloadData()
        }
    }
    
    func eliminaFavorito(evento: Evento) {
        delegado.eliminaFavorito(evento: evento)
        favoritos.remove(at: favoritos.firstIndex(of: evento)!)
        if isfav {
            eventos.remove(at: eventos.firstIndex(of: evento)!)
        }
        // TODO: Esta animación no muestra nada, buscar si se puede animar.
        UIView.animate(withDuration: 1) {
            self.filtrar(day: self.dia)
        }
    }


    
    
    @IBAction func filtroDia(_ sender: UISegmentedControl) {
        dia = sender.selectedSegmentIndex
        filtrar(day: dia)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filtros" {
            let vistaFiltros = segue.destination as! TableViewControllerFiltros
            vistaFiltros.delegado = self
        } else {
            let cell = sender as! TableViewCellEvento
            let vistaDetalle = segue.destination as! ViewControllerDetalleEvento
            vistaDetalle.cellEvento = cell
            vistaDetalle.favSelected = !cell.favSelected
        }
    }
    
}
