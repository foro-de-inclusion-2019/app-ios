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
    
    var filtroAmbito = Ambito.allCases
    var filtroTipo = TipoDiscapacidad.allCases
    
    var eventos = [Evento]()
    var favoritos = [Evento]()
    var eventosFiltrados = [Evento]()
    
    var delegado: cambiaFavorito!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filtrar()
    }
    
    func filtrar() {
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaEvento", for: indexPath) as! TableViewCellEvento
        let evento = eventosFiltrados[indexPath.row]
        let isFavorito = favoritos.contains(evento)
        
        cell.load(evento: evento, delegado: self, isFavorito: isFavorito)
        
        return cell
    }
    
    // Mark: - Protocol actualizaFiltros
    
    func actualizarFiltros(ambitos: [Ambito], tipos: [TipoDiscapacidad]) {
        filtroAmbito = ambitos
        filtroTipo = tipos
        filtrar()
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
        // TODO: Esta animación no muestra nada, buscar si se puede animar.
        UIView.animate(withDuration: 1) {
            self.tablaEventos.reloadData()
        }
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
