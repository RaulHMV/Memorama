//
//  GestorDeAudio.swift
//  Memorama
//
//  Created by Victor on 12/5/25.
//

import UIKit
import AVFoundation

class GestorDeAudio: NSObject, AVAudioPlayerDelegate {
    
    // Singleton
    static let compartido = GestorDeAudio()
    
    var reproductorMusica: AVAudioPlayer?
    var reproductoresSonido: [AVAudioPlayer] = []
    var musicaSilenciada = false
    
    private override init() {
        super.init()
        configurarSesionDeAudio()
    }
    
    // Configurar la sesión de audio
    func configurarSesionDeAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Error al configurar sesión de audio
        }
    }
    
    // Reproducir música de fondo en loop
    func reproducirMusica() {
        guard let rutaMusica = Bundle.main.path(forResource: "musica", ofType: "mp3") else {
            return
        }
        
        let urlMusica = URL(fileURLWithPath: rutaMusica)
        
        do {
            reproductorMusica = try AVAudioPlayer(contentsOf: urlMusica)
            reproductorMusica?.numberOfLoops = -1 // Loop infinito
            reproductorMusica?.volume = 0.5
            reproductorMusica?.prepareToPlay()
            
            if !musicaSilenciada {
                reproductorMusica?.play()
            }
        } catch {
            // Error al cargar música
        }
    }
    
    // Reproducir sonido de botón una sola vez
    func reproducirSonidoBoton() {
        guard let rutaSonido = Bundle.main.path(forResource: "Tocar", ofType: "mp3") else {
            return
        }
        
        let urlSonido = URL(fileURLWithPath: rutaSonido)
        
        do {
            let nuevoReproductor = try AVAudioPlayer(contentsOf: urlSonido)
            nuevoReproductor.delegate = self
            nuevoReproductor.volume = 1.0
            nuevoReproductor.prepareToPlay()
            nuevoReproductor.play()
            
            // Agregar a la lista para mantenerlo en memoria
            reproductoresSonido.append(nuevoReproductor)
        } catch {
            // Error al cargar sonido
        }
    }
    
    // Delegate para limpiar reproductores cuando terminen
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = reproductoresSonido.firstIndex(of: player) {
            reproductoresSonido.remove(at: index)
        }
    }
    
    // Alternar silencio (pausa/reanuda la música)
    func alternarSilencio() {
        if let musica = reproductorMusica {
            if musica.isPlaying {
                musica.pause()
                musicaSilenciada = true
            } else {
                musica.play()
                musicaSilenciada = false
            }
            
            // Guardar estado en UserDefaults
            UserDefaults.standard.set(musicaSilenciada, forKey: "musicaSilenciada")
        }
    }
}
