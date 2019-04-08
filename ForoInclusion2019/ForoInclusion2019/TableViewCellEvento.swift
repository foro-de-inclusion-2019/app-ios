//
//  TableViewCellEvento.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

protocol cambiaFavorito {
    func agregaFavorito(evento: Evento)
    func eliminaFavorito(evento: Evento)
}

class TableViewCellEvento: UITableViewCell {
    
    @IBOutlet weak var tfNombreEvento: UILabel!
    @IBOutlet weak var tfDescripcion: UILabel!
    @IBOutlet weak var tfAmbitosTipos: UILabel!
    @IBOutlet weak var tfHora: UILabel!
    @IBOutlet weak var imgFavorito: UIImageView!
    
    let fotoFavorito = UIImage(named: "Fav")
    let fotoFavoritoSelected = UIImage(named: "FavBold")
    var favSelected: Bool = false
    
    var evento: Evento!
    var delegado: cambiaFavorito!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchFavorito() {
        if favSelected {
            imgFavorito.image = fotoFavorito
            delegado.eliminaFavorito(evento: evento)
            favSelected = false
        } else {
            imgFavorito.image = fotoFavoritoSelected
            delegado.agregaFavorito(evento: evento)
            favSelected = true
        }
    }
    
    @IBAction func clickFavorito(_ sender: UIButton) {
        switchFavorito()
    }
    
    func load(evento: Evento, delegado: cambiaFavorito, isFavorito: Bool) {
        self.evento = evento
        
        tfNombreEvento.text = evento.nombre
        
        if evento.tipo != nil {
            tfDescripcion.text = evento.tipo
        } else {
            tfDescripcion.text = "Tipo por definir"
        }
        
        if evento.hora != nil {
            tfHora.text = evento.hora
        } else {
            tfHora.text = "ND"
        }
        
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
        tfAmbitosTipos.text = ambitosTipos
        
        self.delegado = delegado

        if isFavorito {
            imgFavorito.image = fotoFavoritoSelected
            favSelected = true
        } else {
            imgFavorito.image = fotoFavorito
            favSelected = false
        }
    }
}
