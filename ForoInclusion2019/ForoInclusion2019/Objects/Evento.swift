//
//  Evento.swift
//  ForoInclusion2019
//
//  Created by Samuel Pacheco on 3/21/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

enum Ambito : String, CaseIterable {
    case Social = "Social"
    case Laboral = "Laboral"
    case Salud = "Salud"
    case Escolar = "Escolar"
}

enum TipoDiscapacidad : String, CaseIterable {
    case Visual = "Visual"
    case Auditiva = "Auditiva"
    case Psicosocial = "Psicosocial"
    case Motriz = "Motriz"
    case Intelectual = "Intelectual"
}

class Evento: NSObject {
    
    var nombre: String
    var participantes: String!
    var tipo: String!
    var lugar: String!
    var fecha: String
    var hora: String!
    var ambitos = [Ambito]()
    var tiposDiscapacidad = [TipoDiscapacidad]()
    
    override init() {
        nombre = ""
        fecha = ""
        super.init()
    }
    
    /*
    init(nombre: String, description: String, fecha: String, hora: String) {
        self.nombre = nombre
        self.fecha = fecha
        self.hora = hora
        participantes = ""
        tipo = ""
        lugar = ""
        ambitos = [Ambito]()
        tiposDiscapacidad = [TipoDiscapacidad]()
        super.init()
    }
    */
}
