//
//  TableViewCellEvento.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class TableViewCellEvento: UITableViewCell {
    
    @IBOutlet weak var tfNombreEvento: UILabel!
    @IBOutlet weak var tfDescripcion: UILabel!
    @IBOutlet weak var tfAmbitosTipos: UILabel!
    @IBOutlet weak var tfHora: UILabel!
    @IBOutlet weak var imgFavorito: UIImageView!
    
    let fotoFavorito = UIImage(named: "Fav")
    let fotoFavoritoSelected = UIImage(named: "FavBold")
    var favSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickFavorito(_ sender: UIButton) {
        if favSelected {
            imgFavorito.image = fotoFavorito
            favSelected = false
        } else {
            imgFavorito.image = fotoFavoritoSelected
            favSelected = true
        }
    }

}
