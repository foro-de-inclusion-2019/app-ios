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
    

    func getDate(ev: Evento)->String{
        ev.fecha = String(ev.fecha.map{ ($0 == "-" ? "/" : $0) })
        return ev.fecha
    }
    
    func calculateDays(){
        //calculate day for all events

        
        var allFechas = [Date]()
        
        
        let formater = DateFormatter()
            //2019-04-26
        formater.dateFormat = "yyyy/MM/dd"
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
        allFechas.sort()
        for ev in eventos{
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
    
    
    
    func storeData(){
        
        do{
        let data = try PropertyListEncoder().encode(eventos)
        let favs = try PropertyListEncoder().encode(favoritos)
        try data.write(to: Evento.eventosPath)
        try favs.write(to: Evento.favoritosPath)
        }
        catch{
            print("Save failed")
        }
    }
    
    
    func retrieveEventos() -> [Evento]? {
        do {
            let data = try Data.init(contentsOf: Evento.eventosPath)
            let Ev = try PropertyListDecoder().decode([Evento].self, from: data)
            return Ev
        } catch {
            return nil
        }
    }
    
    
    func retrieveFavoritos() -> [Evento]? {
        do {
            let data = try Data.init(contentsOf: Evento.favoritosPath)
            let ev = try PropertyListDecoder().decode([Evento].self, from: data)
            return ev
        } catch {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dia = 0
        
        if eventos.count == 0{
            //Try to load from file
            if let ev = retrieveEventos() {
                eventos = ev
            }
            
            if let ev = retrieveFavoritos(){
                favoritos = ev
            }
            
        }else{
            //update file :D
            storeData()
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
                if filtroAmbito.contains(ambito) && !eventosFiltrados.contains(evento){
                    eventosFiltrados.append(evento)
                    break
                }
            }
            for tipo in evento.tiposDiscapacidad {
                if filtroTipo.contains(tipo) && !eventosFiltrados.contains(evento){
                    eventosFiltrados.append(evento)
                    break
                }
            }
        }
        var Aux = [Evento]()
        for evento in eventosFiltrados {
            if evento.dia == dia{
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
