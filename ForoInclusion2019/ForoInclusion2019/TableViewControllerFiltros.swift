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
    
    let alertaFiltros = UIAlertController(title: "No hay filtros", message: "No se seleccionaron filtros", preferredStyle: .alert)

    var delegado: actualizaFiltros!
    
    var ambitos = Ambito.allCases
    var tipos = TipoDiscapacidad.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let btnAplicar = UIBarButtonItem(title: "Aplicar", style: .done, target: self, action: #selector(actualizar))
        
        self.navigationItem.rightBarButtonItem = btnAplicar
        
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertaFiltros.addAction(ok)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return ambitos.count
        } else {
            return tipos.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaFiltro", for: indexPath) as! TableViewCellFiltro

        if indexPath.section == 0 {
            cell.tfFiltro.text = ambitos[indexPath.row].rawValue
        } else {
            cell.tfFiltro.text = tipos[indexPath.row].rawValue
        }

        return cell
    }

    @objc func actualizar() {
        
        var ambitos = [Ambito]()
        var tipos = [TipoDiscapacidad]()
        
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
        
        if ambitos.isEmpty && tipos.isEmpty {
            present(alertaFiltros, animated: true, completion: nil)
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
