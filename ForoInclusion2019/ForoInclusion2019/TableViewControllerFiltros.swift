//
//  TableViewControllerFiltros.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/20/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

protocol actualizaFiltros {
    func actualizarFiltros(ambitos: [Ambito], tipos: [TipoDiscapacidad])
}

class TableViewControllerFiltros: UITableViewController {
    
    var delegado: actualizaFiltros!
    
    var filtroAmbito: [Ambito]!
    var filtroTipo: [TipoDiscapacidad]!
    
    var ambitos = Ambito.allCases
    var tipos = TipoDiscapacidad.allCases
    
    var cellHeight : CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ámbitos"
        } else {
            return "Tipos de discapacidad"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHeight + 10.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return ambitos.count
        } else {
            return tipos.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaFiltro", for: indexPath) as! TableViewCellFiltro

        if indexPath.section == 0 {
            let ambito = ambitos[indexPath.row]
            cell.tfFiltro.text = ambito.rawValue
            if filtroAmbito.contains(ambito) {
                cell.doSwitch(on: true)
            }
        } else {
            let tipo = tipos[indexPath.row]
            cell.tfFiltro.text = tipo.rawValue
            if filtroTipo.contains(tipo) {
                cell.doSwitch(on: true)
            }
        }
        
        cellHeight = cell.getFontSize()

        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        ambitos = [Ambito]()
        tipos = [TipoDiscapacidad]()
        
        let indexes = tableView.indexPathsForVisibleRows!
        
        for index in indexes {
            let cell = tableView.cellForRow(at: index) as! TableViewCellFiltro
            
            if index.section == 0 {
                if cell.isOn {
                    let ambito = Ambito.init(rawValue: cell.tfFiltro.text!)!
                    ambitos.append(ambito)
                }
            } else {
                if cell.isOn {
                    let tipo = TipoDiscapacidad.init(rawValue: cell.tfFiltro.text!)!
                    tipos.append(tipo)
                }
            }
        }
        
        delegado.actualizarFiltros(ambitos: ambitos, tipos: tipos)
        
        super.viewDidDisappear(true)
    }

}
