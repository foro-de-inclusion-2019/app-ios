//
//  ViewController.swift
//  ForoInclusion2019
//
//  Created by Alumno on 3/19/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
        
        showAlert(functionality: "Alto contraste")
    
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

