//
//  Evento.swift
//  ForoInclusion2019
//
//  Created by Samuel Pacheco on 3/21/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

enum Ambito : String, CaseIterable, Codable {
    case Social = "Social"
    case Laboral = "Laboral"
    case Salud = "Salud"
    case Escolar = "Estudiantil"
}

enum TipoDiscapacidad : String, CaseIterable, Codable {
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





class Evento: NSObject, Codable{
    
    
    static let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let eventosPath = documentDirectory.appendingPathComponent("Eventos")
    static let favoritosPath = documentDirectory.appendingPathComponent("Favoritos")

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nombre, forKey: .nombre)
        try container.encode(participantes, forKey: .participantes)
        try container.encode(tipo, forKey: .tipo)
        try container.encode(lugar, forKey: .lugar)
        try container.encode(fecha, forKey: .fecha)
        try container.encode(hora, forKey: .hora)
        try container.encode(dia, forKey: .Dia)
        //ambitos
        try container.encode(self.ambitos, forKey: .ambitos)//
        //tiposDiscapacidad
        try container.encode(self.tiposDiscapacidad, forKey: .tiposDiscapacidad)
    }


    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        nombre = try container.decode(String.self, forKey: .nombre)
        participantes = try container.decode(String.self, forKey: .participantes)
        tipo = try container.decode(String.self, forKey: .tipo)
        lugar = try container.decode(String.self, forKey: .lugar)
        fecha = try container.decode(String.self, forKey: .fecha)
        hora = try container.decode(String.self, forKey: .hora)
        dia = try container.decode(Int.self, forKey: .Dia)
        ambitos = try container.decode([Ambito].self, forKey: .ambitos)
        tiposDiscapacidad = try container.decode([TipoDiscapacidad].self, forKey: .tiposDiscapacidad)
    }

    var nombre: String // String
    var participantes: String? // Array String
    var tipo: String? // String
    var lugar: String? // String
    var fecha: String // String
    var hora: String? // String
    var ambitos = [Ambito]() // Array String
    var tiposDiscapacidad = [TipoDiscapacidad]() // Array String
    var dia: Int
    
    override init() {
        nombre = ""
        fecha = ""
        dia = -1
        super.init()
    }
    
    init(nombre: String, participantes: String?, tipo: String?, lugar: String?, fecha: String, hora: String?, ambitos: [String], tiposDiscapacidad: [String], dia: Int) {
        self.nombre = nombre
        self.participantes = participantes
        self.tipo = tipo
        self.lugar = lugar
        self.fecha = fecha
        self.hora = hora
        self.dia = dia
        
        for ambito in ambitos {
            if let amb = Ambito(rawValue: ambito){
                self.ambitos.append(amb)
            }
        }
        
        for tipo in tiposDiscapacidad {
            if let disc = TipoDiscapacidad(rawValue: tipo){
                self.tiposDiscapacidad.append(disc)
            }
        }
    }
    
}
