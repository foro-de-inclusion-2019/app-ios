//
//  ViewControllerEvento.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class ViewControllerDetalleEvento: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tfNombre: UILabel!
    @IBOutlet weak var imgFavorito: UIImageView!
    @IBOutlet weak var btnFavorito: UIButton!
    
    @IBOutlet weak var tablaGuadiana: UITableView!
    
    var celdas = [UITableViewCell]()
    
    var cellEvento = TableViewCellEvento()
    
    var cellSize : CGFloat = 20
    
    var evento: Evento!
    var favSelected: Bool!
    
    let fotoFavorito = UIImage(named: "Fav")
    let fotoFavoritoSelected = UIImage(named: "FavBold")
    
    let app = UIApplication.shared
    
    @objc func reload(){
        tablaGuadiana.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        evento = cellEvento.evento
        
        tfNombre.text = evento.nombre
        
        switchFavorito()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: UIApplication.didBecomeActiveNotification, object: app)
        
    }
    
    func switchFavorito() {
        if favSelected {
            imgFavorito.image = fotoFavorito
            favSelected = false
        } else {
            imgFavorito.image = fotoFavoritoSelected
            favSelected = true
        }
    }
    
    @IBAction func clickFavorito(_ sender: UIButton) {
        switchFavorito()
        cellEvento.switchFavorito()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let cellTipo = UITableViewCell()
        let cellParticipantes = UITableViewCell()
        let cellFecha = UITableViewCell()
        let cellLugar = UITableViewCell()
        let cellAmbitosTipos = UITableViewCell()
        
        var count = 0
        
        // Give capacity of 3 lines to each label
        cellTipo.textLabel?.numberOfLines = 3
        cellParticipantes.textLabel?.numberOfLines = 3
        cellFecha.textLabel?.numberOfLines = 3
        cellLugar.textLabel?.numberOfLines = 3
        cellAmbitosTipos.textLabel?.numberOfLines = 3
        
        // Actualizar tamaño de celda en base al tamaño de la letra
        //cellSize = tfNombre.font.capHeight
        
        if evento.tipo != nil {
            cellTipo.textLabel?.text = evento.tipo
            cellTipo.imageView?.image = UIImage(named: "info")
            celdas.append(cellTipo)
            count += 1
        }
        if evento.participantes != nil {
            cellParticipantes.textLabel?.text = evento.participantes
            cellParticipantes.imageView?.image = UIImage(named: "person")
            celdas.append(cellParticipantes)
            count += 1
        }
        
        cellFecha.textLabel?.text = evento.fecha
        cellFecha.imageView?.image = UIImage(named: "calendar")
        celdas.append(cellFecha)
        count += 1
        
        if evento.hora != nil {
            cellFecha.detailTextLabel?.text = evento.hora
        } else {
            cellFecha.detailTextLabel?.text = "Horario por definir"
        }
        if evento.lugar != nil {
            cellLugar.textLabel?.text = evento.lugar
        } else {
            cellLugar.textLabel?.text = "Lugar por definir"
        }
        cellLugar.imageView?.image = UIImage(named: "location")
        celdas.append(cellLugar)
        count += 1
        
        if !evento.ambitos.isEmpty || !evento.tiposDiscapacidad.isEmpty {
            var ambitosTipos = ""
            if !evento.tiposDiscapacidad.isEmpty {
                ambitosTipos += "Tipos de discapacidad: "
                for tipo in evento.tiposDiscapacidad {
                    ambitosTipos += tipo.rawValue + ", "
                }
                ambitosTipos = String(ambitosTipos.dropLast(2))
                ambitosTipos += "\n"
            }
            if !evento.ambitos.isEmpty {
                ambitosTipos += "Ámbitos: "
                for ambito in evento.ambitos {
                    ambitosTipos += ambito.rawValue + ", "
                }
                ambitosTipos = String(ambitosTipos.dropLast(2))
            }
            cellAmbitosTipos.textLabel?.text = ambitosTipos
            cellAmbitosTipos.imageView?.image = UIImage(named: "tipoD")
            celdas.append(cellAmbitosTipos)
            count += 1
        }
        
        return count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSize * 1.2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vista = UIView()
        vista.backgroundColor = UIColor.clear
        return vista
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "detalle", for: indexPath)
        
        cell = celdas[indexPath.section]
        
        return cell
    }

}
