//
//  juegoViewController.swift
//  Memorama
//
//  Created by Victor on 12/5/25.
//

import UIKit

class juegoViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Propiedades del juego
    var cartasTablero: [String] = []
    var cartasDestapadas: [Bool] = []
    var indicesPrimeraCarta: IndexPath?
    var indicesSegundaCarta: IndexPath?
    var bloqueado = false
    var aciertos = 0
    var errores = 0
    var segundos = 0
    var temporizador: Timer?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "CeldaCarta", for: indexPath)
        
        // Obtener el UIImageView de la celda usando tag 10
        if let imagenCarta = celda.viewWithTag(10) as? UIImageView {
            // Limpiar configuración previa
            imagenCarta.backgroundColor = .clear
            
            if cartasDestapadas[indexPath.row] {
                // Carta destapada - mostrar imagen real
                let nombreImagen = cartasTablero[indexPath.row]
                imagenCarta.image = UIImage(named: nombreImagen)
            } else {
                // Carta tapada - mostrar reverso
                imagenCarta.image = UIImage(named: "reverso.png")
            }
            
            // Configurar el modo de contenido
            imagenCarta.contentMode = .scaleAspectFill
            imagenCarta.clipsToBounds = true
        }
        
        return celda
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // No hacer nada si el juego está bloqueado o la carta ya está destapada
        if bloqueado || cartasDestapadas[indexPath.row] {
            return
        }
        
        // Destapar la carta
        cartasDestapadas[indexPath.row] = true
        collectionView.reloadItems(at: [indexPath])
        
        if indicesPrimeraCarta == nil {
            // Es la primera carta
            indicesPrimeraCarta = indexPath
        } else if indicesSegundaCarta == nil {
            // Es la segunda carta
            indicesSegundaCarta = indexPath
            bloqueado = true
            
            // Comparar las dos cartas
            verificarPareja()
        }
    }
    
    func verificarPareja() {
        guard let primera = indicesPrimeraCarta, let segunda = indicesSegundaCarta else { return }
        
        if cartasTablero[primera.row] == cartasTablero[segunda.row] {
            // ¡Acierto!
            aciertos += 1
            
            // Desbloquear para continuar
            indicesPrimeraCarta = nil
            indicesSegundaCarta = nil
            bloqueado = false
            
            // Verificar si ganó
            if aciertos == 8 {
                finalizarJuego()
            }
        } else {
            // Error - esperar 1 segundo y voltear las cartas
            errores += 1
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.cartasDestapadas[primera.row] = false
                self.cartasDestapadas[segunda.row] = false
                self.clvTablero.reloadItems(at: [primera, segunda])
                
                self.indicesPrimeraCarta = nil
                self.indicesSegundaCarta = nil
                self.bloqueado = false
            }
        }
        
        // Actualizar puntos
        actualizarPuntos()
    }
    
    func actualizarPuntos() {
        let puntos = max(0, 1000 - (2 * segundos) - (10 * errores))
        lblPuntos.text = "\(puntos)"
    }
    
    func finalizarJuego() {
        // Detener el temporizador
        temporizador?.invalidate()
        
        // Calcular puntaje final
        let puntajeFinal = max(0, 1000 - (2 * segundos) - (10 * errores))
        
        // Verificar si es récord
        if GestorDePuntuaciones.compartido.esRecord(puntos: puntajeFinal) {
            // ES RÉCORD - Pedir nombre
            let alerta = UIAlertController(title: "¡Récord!", message: "¡Felicidades! Has logrado un nuevo récord con \(puntajeFinal) puntos", preferredStyle: .alert)
            
            alerta.addTextField { textField in
                textField.placeholder = "Ingresa tu nombre"
            }
            
            let accionGuardar = UIAlertAction(title: "Guardar", style: .default) { _ in
                if let nombre = alerta.textFields?[0].text, !nombre.isEmpty {
                    GestorDePuntuaciones.compartido.guardarRecord(nombre: nombre, puntos: puntajeFinal)
                }
                self.dismiss(animated: true, completion: nil)
            }
            
            alerta.addAction(accionGuardar)
            present(alerta, animated: true, completion: nil)
        } else {
            // NO ES RÉCORD - Alerta simple
            let alerta = UIAlertController(title: "¡Ganaste!", message: "Has completado el juego con \(puntajeFinal) puntos", preferredStyle: .alert)
            
            let accionSalir = UIAlertAction(title: "Salir", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            
            alerta.addAction(accionSalir)
            present(alerta, animated: true, completion: nil)
        }
    }
    
    func iniciarTemporizador() {
        temporizador = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.segundos += 1
            self.lblTiempo.text = "\(self.segundos)"
            self.actualizarPuntos()
        }
    }
    
    func generarCartas() {
        // Pool de 12 nombres de imagen CON extensión
        let poolCartas = ["carta1.jpeg", "carta2.jpeg", "carta3.jpeg", "carta4.jpeg", "carta5.jpeg", "carta6.jpeg", 
                         "carta7.jpeg", "carta8.jpeg", "carta9.jpeg", "carta10.jpeg", "carta11.jpeg", "carta12.jpeg"]
        
        // Elegir 8 distintas al azar
        var cartasSeleccionadas = Array(poolCartas.shuffled().prefix(8))
        
        // Duplicar las cartas
        cartasSeleccionadas.append(contentsOf: cartasSeleccionadas)
        
        // Barajar las 16 cartas
        cartasTablero = cartasSeleccionadas.shuffled()
        
        // Inicializar array de cartas destapadas (todas tapadas al inicio)
        cartasDestapadas = Array(repeating: false, count: 16)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generar cartas PRIMERO
        generarCartas()
        
        // Configurar collection view DESPUÉS
        clvTablero.delegate = self
        clvTablero.dataSource = self
        
        // Inicializar puntos y tiempo
        lblPuntos.text = "1000"
        lblTiempo.text = "0"
        
        // Iniciar temporizador
        iniciarTemporizador()
        
        // Recargar datos para asegurar que se muestren correctamente
        clvTablero.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Configurar layout después de que se establezcan los tamaños reales
        configurarLayoutCollectionView()
    }
    
    func configurarLayoutCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        // Usar el ancho y alto real del collection view
        let anchoCollectionView = clvTablero.bounds.width
        let altoCollectionView = clvTablero.bounds.height
        
        // Calcular espaciado proporcional
        let espaciado: CGFloat = 6
        let margen: CGFloat = 6
        
        // Calcular tamaño de celda basado en 4 columnas
        let espacioHorizontalTotal = (espaciado * 3) + (margen * 2)
        let anchoDisponible = anchoCollectionView - espacioHorizontalTotal
        let anchoCelda = floor(anchoDisponible / 4)
        
        // Calcular tamaño de celda basado en 4 filas
        let espacioVerticalTotal = (espaciado * 3) + (margen * 2)
        let altoDisponible = altoCollectionView - espacioVerticalTotal
        let altoCelda = floor(altoDisponible / 4)
        
        // Usar el menor de los dos para mantener celdas cuadradas
        let tamañoCelda = min(anchoCelda, altoCelda)
        
        layout.itemSize = CGSize(width: tamañoCelda, height: tamañoCelda)
        layout.minimumInteritemSpacing = espaciado
        layout.minimumLineSpacing = espaciado
        layout.sectionInset = UIEdgeInsets(top: margen, left: margen, bottom: margen, right: margen)
        layout.scrollDirection = .vertical
        
        clvTablero.collectionViewLayout = layout
        clvTablero.isScrollEnabled = false
    }
    
    @IBOutlet weak var clvTablero: UICollectionView!
    
    @IBOutlet weak var lblTiempo: UILabel!
    
    @IBOutlet weak var lblPuntos: UILabel!
    
    
    @IBAction func Salir(_ sender: UIButton) {
        // Reproducir sonido de botón
        GestorDeAudio.compartido.reproducirSonidoBoton()
        
        // Detener temporizador
        temporizador?.invalidate()
        
        // Salir del juego
        dismiss(animated: true, completion: nil)
    }
}
