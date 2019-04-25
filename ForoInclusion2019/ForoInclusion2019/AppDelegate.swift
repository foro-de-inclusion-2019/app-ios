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

    // Receives events dictionary and stores it in global var
    func saveEventsToVariable( tmpEvents: NSDictionary ) {
        
        for event in tmpEvents {
            // TO-DO
            // Sacar cada variable del evento y enviarlo al constructor, como se especifica en clase Evento
            print("TEST")
            print(event)
            
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
            print("Events dictionary: ")
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
