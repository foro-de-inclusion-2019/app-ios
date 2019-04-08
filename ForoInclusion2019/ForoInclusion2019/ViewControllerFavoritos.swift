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
    
    var favoritos: [Evento]!
    var delegado: cambiaFavorito!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(favoritos)
        return favoritos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaEvento", for: indexPath) as! TableViewCellEvento
        let evento = favoritos[indexPath.row]
        
        cell.load(evento: evento, delegado: self, isFavorito: true)
        
        return cell
    }
    
    // MARK: - Protocol cambiaFavorito
    
    func agregaFavorito(evento: Evento) {
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
