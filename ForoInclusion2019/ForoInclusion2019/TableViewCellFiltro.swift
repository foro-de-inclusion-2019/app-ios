//
//  TableViewCellFiltro.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/20/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class TableViewCellFiltro: UITableViewCell {

    @IBOutlet weak var tfFiltro: UILabel!
    @IBOutlet weak var switchFiltro: UISwitch!
    
    var isOn = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getFontSize() -> CGFloat{
        return tfFiltro.font.capHeight
    }
    
    func doSwitch(on: Bool) {
        switchFiltro.isOn = on
        isOn = on
    }

    @IBAction func switched(_ sender: UISwitch) {
        if sender.isOn {
            isOn = true
        } else {
            isOn = false
        }
    }
}
