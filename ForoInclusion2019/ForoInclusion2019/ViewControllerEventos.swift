//
//  ViewControllerEventos.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class ViewControllerEventos: UIViewController, UITableViewDataSource, UITableViewDelegate, actualizaFiltros {
    
    @IBOutlet weak var tablaEventos: UITableView!
    
    var filtroAmbito = Ambito.allCases
    var filtroTipo = TipoDiscapacidad.allCases
    
    var eventos = [Evento]()
    var eventosFiltrados = [Evento]()
    
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
        
        cell.tfNombreEvento.text = evento.nombre
        cell.tfDescripcion.text = evento.tipo
        cell.tfHora.text = evento.hora
        
        var ambitosTipos = ""
        for tipo in evento.tiposDiscapacidad {
            ambitosTipos += tipo.rawValue + ", "
        }
        for ambito in evento.ambitos {
            ambitosTipos += ambito.rawValue + ", "
        }
        if (!ambitosTipos.isEmpty) {
            ambitosTipos = String(ambitosTipos.dropLast(2))
        }
        cell.tfAmbitosTipos.text = ambitosTipos
        
        return cell
    }
    
    func actualizarFiltros(ambitos: [Ambito], tipos: [TipoDiscapacidad]) {
        filtroAmbito = ambitos
        filtroTipo = tipos
        filtrar()
        tablaEventos.reloadData()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filtros" {
            let vistaFiltros = segue.destination as! TableViewControllerFiltros
            vistaFiltros.delegado = self
        }
    }
    
}
