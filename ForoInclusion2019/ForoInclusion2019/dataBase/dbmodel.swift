//
//  dbmodel.swift
//  ForoInclusion2019
//
//  Created by Samuel Pacheco on 3/21/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class dbmodel: NSObject {

    //Mi instancia a la base de datos
    let mydb = dataBase()
    
    
    override init() {
        //OK?
    }
    
    
    func retrieveEvents() -> [Evento]{
        let data = [Evento]()
        
        let eventos = mydb.retrieveJSON()
        
        //Parse data from eventos
        
        
        
        
        return data
    }
    
}
