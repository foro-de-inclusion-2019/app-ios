//
//  Evento.swift
//  ForoInclusion2019
//
//  Created by Samuel Pacheco on 3/21/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

enum Ambito : String, CaseIterable, Decodable, CodingKey {
    case Social = "Social"
    case Laboral = "Laboral"
    case Salud = "Salud"
    case Escolar = "Escolar"
}

enum TipoDiscapacidad : String, CaseIterable, Decodable {
    case Visual = "Visual"
    case Auditiva = "Auditiva"
    case Psicosocial = "Psicosocial"
    case Motriz = "Motriz"
    case Intelectual = "Intelectual"
}


enum CodingKeys: String, CodingKey{
    case nombre
    case participantes
    case tipo
    case lugar
    case fecha
    case hora
    case ambitos
    case tiposDiscapacidad
    case Dia
}




class Evento: NSObject {
//
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(nombre, forKey: .nombre)
//        try container.encode(participantes, forKey: .participantes)
//        try container.encode(tipo, forKey: .tipo)
//        try container.encode(lugar, forKey: .lugar)
//        try container.encode(fecha, forKey: .fecha)
//        try container.encode(hora, forKey: .hora)
//        try container.encode(Dia, forKey: .Dia)
//
//
//
//
//
//
//
//        //try container.encode(ambitos, forKey: .ambitos)
//
//        //Ambitos
//
//
//
//        //Tipos de disapacidad
//
//    }
//
//
//    required init(from decoder: Decoder) throws {
//
//    }
//
    var nombre: String // String
    var participantes: String! // Array String
    var tipo: String! // String
    var lugar: String! // String
    var fecha: String // String
    var hora: String! // String
    var ambitos = [Ambito]() // Array String
    var tiposDiscapacidad = [TipoDiscapacidad]() // Array String
    var Dia: Int
    
    override init() {
        nombre = ""
        fecha = ""
        Dia = -1
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
