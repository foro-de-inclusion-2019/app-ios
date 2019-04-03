//
//  ViewController.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        evento1.fecha = "21 de abril"
        evento1.hora = "12:30"
        evento1.ambitos.append(Ambito.Escolar)
        
        let evento2 = Evento()
        evento2.nombre = "El panel de panelistas panelosos"
        evento2.participantes = "Juan Perez, Martha Sanchez"
        evento2.tipo = "Panel"
        evento2.lugar = "Centro de congresos, sala 3"
        evento2.fecha = "21 de abril"
        evento2.hora = "14:30"
        evento2.ambitos.append(Ambito.Escolar)
        
        eventos = [evento1, evento2]
        favoritos = [evento1]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventos" {
            let vistaEventos = segue.destination as! ViewControllerEventos
            vistaEventos.eventos = eventos
        } else {
            let vistaFavoritos = segue.destination as! ViewControllerFavoritos
            vistaFavoritos.favoritos = favoritos
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

