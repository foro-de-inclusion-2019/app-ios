//
//  dataBase.swift
//  ForoInclusion2019
//
//  Created by Samuel Pacheco on 3/21/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class dataBase: NSObject {

    override init(){
        //Connect to DB
        super.init()
        connectToDB()
    }
    
    
    func connectToDB() {
        //TODO: Connect with firebase
    }
    
    
    func retrieveJSON(){
        //TODO: Query to retrieve data from database
    }
}
