//
//  inicioViewController.swift
//  Memorama
//
//  Created by Victor on 12/5/25.
//

import UIKit

class inicioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnJugar(_ sender: UIButton) {
        // Reproducir sonido de botón
        GestorDeAudio.compartido.reproducirSonidoBoton()
        // El segue es automático en el storyboard
    }
    
    @IBAction func btnRecords(_ sender: UIButton) {
        // Reproducir sonido de botón
        GestorDeAudio.compartido.reproducirSonidoBoton()
        // El segue es automático en el storyboard
    }
    
    @IBAction func btnReglas(_ sender: UIButton) {
        // Reproducir sonido de botón
        GestorDeAudio.compartido.reproducirSonidoBoton()
        // El segue es automático en el storyboard
    }
    
    @IBAction func btnMute(_ sender: UIButton) {
        // Reproducir sonido de botón
        GestorDeAudio.compartido.reproducirSonidoBoton()
        
        // Alternar silencio de la música
        GestorDeAudio.compartido.alternarSilencio()
        
        // Cambiar imagen del botón según el estado
        if GestorDeAudio.compartido.musicaSilenciada {
            sender.setImage(UIImage(systemName: "speaker.slash.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        }
    }
}
