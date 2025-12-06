//
//  ViewController.swift
//  Memorama
//
//  Created by Victor on 12/4/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imagenLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preparar el logo para la animación (oculto inicialmente)
        imagenLogo.alpha = 0
        imagenLogo.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Iniciar la música de fondo
        GestorDeAudio.compartido.reproducirMusica()
        
        // Ejecutar animación compuesta (escalado + desvanecimiento) durante 2 segundos
        UIView.animate(withDuration: 2.0, animations: {
            self.imagenLogo.alpha = 1.0
            self.imagenLogo.transform = CGAffineTransform.identity
        }) { _ in
            // Al terminar la animación, navegar al siguiente view controller
            if let inicioVC = self.storyboard?.instantiateViewController(withIdentifier: "inicioViewController") {
                inicioVC.modalPresentationStyle = .fullScreen
                self.present(inicioVC, animated: true, completion: nil)
            }
        }
    }
}

