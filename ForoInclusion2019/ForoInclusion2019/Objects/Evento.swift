//
//  Evento.swift
//  ForoInclusion2019
//
//  Created by Samuel Pacheco on 3/21/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

enum Ambito {
    case Social
    case Laboral
    case Salud
    case Escolar
}

enum TipoDiscapacidad {
    case Visual
    case Auditiva
    case Psicosocial
    case Motriz
    case Intelectual
}

class Evento: NSObject {
    
    var nombre: String
    var descr: String
    var fecha: String
    var hora: String
    var ambitos: [Ambito]
    var tiposDiscapacidad: [TipoDiscapacidad]
    
    init(nombre: String, description: String, fecha: String, hora: String) {
        self.nombre = nombre
        self.descr = description
        self.fecha = fecha
        self.hora = hora
        ambitos = [Ambito]()
        tiposDiscapacidad = [TipoDiscapacidad]()
        super.init()
    }
}
