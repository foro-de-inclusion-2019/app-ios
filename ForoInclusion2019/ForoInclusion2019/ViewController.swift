//
//  ViewController.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class ViewController: UIViewController, cambiaFavorito {

    var eventos: [Evento]!
    var favoritos: [Evento]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Temporalmente llenar los arreglos eventos y favoritos con datos dummy
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
        
        eventos = [evento1, evento2, evento3]
        favoritos = [evento1]
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

