//
//  AppDelegate.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var events = [Evento]()
    
    // Function that returns day number of given date separated by "-"
    func getDia(fecha: String) -> Int {
    
        if( fecha.isEmpty ) {
            return 0;
        }
        
        let arrayFechaNumbers = fecha.components(separatedBy: "-")
        let dia = Int(arrayFechaNumbers[1]) ?? 0
        
        return dia
        
    }

    // Receives events dictionary and stores it in global var
    func saveEventsToVariable( tmpEvents: NSDictionary ) {
        
        let eventKeys = tmpEvents.allKeys as! [String]
        var eventCounter = 0
        
        for key in eventKeys {
            
            let notProcessedEvent = tmpEvents[key] as! NSDictionary
            
            // Get response elements
            let ambitos = notProcessedEvent["ambito"] as? String ?? ""
            let discapacidades = notProcessedEvent["discapidad"] as? String ?? ""
            let nombreEvento = notProcessedEvent["evento"] as? String ?? ""
            let fecha = notProcessedEvent["fecha"] as? String ?? ""
            let horario = notProcessedEvent["horario"] as? String ?? ""
            let lugar = notProcessedEvent["lugar"] as? String ?? ""
            let participantes = notProcessedEvent["participantes"] as? String ?? ""
            let tipoEvento = notProcessedEvent["tipoEventos"] as? String ?? ""
            
            // OJO, aqui checar si estará separado por "comma" o por "comma + espacio"
            // Get special arrays
            let ambitosArray = ambitos.components(separatedBy: ",")
            let discapacidadesArray = discapacidades.components(separatedBy: ",")
            
            // Get day from fecha
            let dia = getDia(fecha: fecha)
            
            // Create event object of type Evento
            let event = Evento(nombre: nombreEvento, participantes: participantes, tipo: tipoEvento, lugar: lugar, fecha: fecha, hora: horario, ambitos: ambitosArray, tiposDiscapacidad: discapacidadesArray, dia: dia)
            
            // Update events array
            events.append(event)
            eventCounter = eventCounter + 1
            
            // Log it, printing last element of array
            print("Event (" + String(eventCounter) + ") created locally: ")
            print(events[eventCounter-1])
            
        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        // Get database reference
        let db = Database.database().reference()
        
        print("DB REFERENCE: ")
        print(db)
        
        // Access database events from db reference
        db.child("eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get events
            let events = snapshot.value as? NSDictionary
            print(events ?? "")
            
            // Store them in variable, aborts execution if events is nil (! at the end and self. does that)
            self.saveEventsToVariable(tmpEvents: events!)
            
        }) { (error) in // Catch error, and print it
            
            print(error.localizedDescription)
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
