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
        
        let evento1 = Evento(nombre: "Panel", description: "Panel sobre bla bla bla", fecha: "20/05/09", hora: "16:00")
        let evento2 = Evento(nombre: "Conferencia", description: "Conferencia sobre bla bla bla", fecha: "20/05/09", hora: "16:00")
        
        evento1.ambitos.append(Ambito.Escolar)
        
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

