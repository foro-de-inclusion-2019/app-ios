//
//  Evento.swift
//  ForoInclusion2019
//
//  Created by Samuel Pacheco on 3/21/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class Evento: NSObject {
    
    var nombre: String
    var descr: String
    var hora: String
    
    
    init(nombre: String, description: String, hora: String) {
        self.nombre = nombre
        self.descr = description
        self.hora = hora
        super.init()
    }

}
