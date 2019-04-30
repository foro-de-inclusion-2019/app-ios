//
//  ViewController.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit
import Network
import Firebase


class ViewController: UIViewController, cambiaFavorito {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate  // Get reference to app delegate
    
    let monitor = NWPathMonitor()                   // Monitors if using (wifi, ethernet, lo0, etc)
    let queue = DispatchQueue(label: "Monitor")     // Queue used to run monitor
    var db : DatabaseReference?                     // Database reference
    var dataIsLoaded = false                        // Verifies if data from db finished loading
    var hasWifi = false;                            // Verfifies if device has internet connection
    
    var eventos = [Evento]()
    var favoritos = [Evento]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load monitor to queue
        monitor.start(queue: queue)
        
        // get database reference from app delegate
        db = appDelegate.db
        
        // fetch events from db
        fetchEvents()
        
    }
    
    
    
    // Temporalmente llenar los arreglos eventos y favoritos con datos dummy
    func fillDummyEvents() {
        let evento1 = Evento()
        evento1.nombre = "La platica muy importante"
        evento1.participantes = "Juan Perez, Martha Sanchez"
        evento1.tipo = "Conferencia"
        evento1.lugar = "Centro de congresos, sala 2"
        evento1.fecha = "2019/04/22"
        evento1.hora = "12:30"
        evento1.ambitos.append(Ambito.Salud)

        let evento2 = Evento()
        evento2.nombre = "El panel de panelistas panelosos"
        evento2.participantes = "Juan Perez, Martha Sanchez"
        evento2.tipo = "Panel"
        evento2.lugar = "Centro de congresos, sala 3"
        evento2.fecha = "2019/04/21"
        evento2.hora = "14:30"
        evento2.ambitos.append(Ambito.Escolar)

        let evento3 = Evento()
        evento3.nombre = "Panel"
        evento3.participantes = "Samuel Pacheco"
        evento3.tipo = "Panel"
        evento3.lugar = "Centro de congresos, sala 3"
        evento3.fecha = "2019/04/23"
        evento3.hora = "14:30"
        evento3.ambitos.append(Ambito.Escolar)
        
        eventos.append(evento1)
        eventos.append(evento2)
        eventos.append(evento3)
        favoritos.append(evento1)
    }
    
    // MARK: - Protocol cambiaFavorito
    
    func agregaFavorito(evento: Evento) {
        favoritos.append(evento)
    }
    
    func eliminaFavorito(evento: Evento) {
        favoritos.remove(at: favoritos.firstIndex(of: evento)!)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventos" {
            let vistaEventos = segue.destination as! ViewControllerEventos
            vistaEventos.eventos = eventos
            vistaEventos.favoritos = favoritos
            vistaEventos.delegado = self
            vistaEventos.isfav = false
        } else {
            let vistaFavoritos = segue.destination as! ViewControllerEventos
            vistaFavoritos.eventos = favoritos
            vistaFavoritos.favoritos = favoritos
            vistaFavoritos.delegado = self
            vistaFavoritos.isfav = true
            vistaFavoritos.title="Favoritos"
            //vistaEventos.isfav = false
        }
    }
    
    
    // MARK: - Wifi Detection
    override func viewWillAppear(_ animated: Bool) {
        
        // Connection detector closure
        monitor.pathUpdateHandler = { path in
            
            if(path.status == .satisfied) { //Detects connection
                
                if( path.isExpensive ) {
                    print("Cellular data is ON.")
                } else {
                    print("INTERNET is ON.")
                }
                
                self.hasWifi = true;
                
            } else { // No connection detected
                print("INTERNET is OFF.")
                
                self.hasWifi = false;
                
            }
            
        }
        
    }
    
    
    
    
    // MARK: - Database Stuff
    
    
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
            let discapacidades = notProcessedEvent["discapacidad"] as? String ?? ""
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
            // let dia = getDia(fecha: fecha)
            
            // Create event object of type Evento
            let event = Evento(nombre: nombreEvento, participantes: participantes, tipo: tipoEvento, lugar: lugar, fecha: fecha, hora: horario, ambitos: ambitosArray, tiposDiscapacidad: discapacidadesArray, dia: -1)
            
            // Update events array
            eventos.append(event)
            eventCounter = eventCounter + 1
            
            // Log it, printing last element of array
            print("Event (" + String(eventCounter) + ") created locally: ")
            print(eventos[eventCounter-1])
            
        }
        
        print("EVENTS LOADED: ", eventCounter)
        
        dataIsLoaded = true
        
    }
    
    
    // Access db reference to retrieve events
    func fetchEvents() {
        
        // If data is loaded already OR user has no internet, return
        if( dataIsLoaded ) {
            return
        }
        
        // Get database reference
        db = Database.database().reference()
        
        print("DB REFERENCE: ")
        print(db ?? "")
        
        // Access database events from db reference
        db?.child("eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get events
            let events = snapshot.value as? NSDictionary
            print(events ?? "")
            
            // Store them in variable, aborts execution if events is nil (! at the end and self. does that)
            self.saveEventsToVariable(tmpEvents: events!)
            
        }) { (error) in // Catch error, and print it
            
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
    // MARK: - Accesibility
    
    /*
     * Method which receives a functionality name and appends it to alert, showing the path in which you can activate it.
     */
    func showAlert( functionality: String ){
        
        let alertController = UIAlertController (title: functionality, message: "Ir a Configuración > General > " + functionality, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Configuración", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                    print(settingsUrl)
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    /* Leftmost button is clicked */
    @IBAction func activateHighContrast(_ sender: Any) {

        showAlert(functionality: "Aumentar el contraste")
    
    }

    /* Middle button is clicked */
    @IBAction func activateVoiceOver(_ sender: Any) {
        
        showAlert(functionality: "Voice over")
        
    }
    
    /* Rightmost button is clicked */
    @IBAction func activateBigLetters(_ sender: Any) {
    
        showAlert(functionality: "Texto Grande")
    
    }
}

