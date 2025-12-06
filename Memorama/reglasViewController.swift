//
//  reglasViewController.swift
//  Memorama
//
//  Created by Victor on 12/5/25.
//

import UIKit

class reglasViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnRegresar(_ sender: UIButton) {
        // Reproducir sonido de botón
        GestorDeAudio.compartido.reproducirSonidoBoton()
        
        // Regresar
        dismiss(animated: true, completion: nil)
    }
}
