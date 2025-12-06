//
//  recordsViewController.swift
//  Memorama
//
//  Created by Victor on 12/5/25.
//

import UIKit

class recordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var records: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar tabla
        tbvRecords.delegate = self
        tbvRecords.dataSource = self
        
        // Cargar datos del gestor
        records = GestorDePuntuaciones.compartido.obtenerRecords()
        
        // Recargar tabla
        tbvRecords.reloadData()
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "CeldaRecord") ?? UITableViewCell(style: .default, reuseIdentifier: "CeldaRecord")
        
        let record = records[indexPath.row]
        let posicion = indexPath.row + 1
        let nombre = record["nombre"] as? String ?? "Desconocido"
        let puntos = record["puntos"] as? Int ?? 0
        
        // Mostrar "Posición - Nombre - Puntos"
        celda.textLabel?.text = "\(posicion). \(nombre) - \(puntos) pts"
        
        return celda
    }

    @IBOutlet weak var tbvRecords: UITableView!
    
    @IBAction func btnRegresar(_ sender: UIButton) {
        // Reproducir sonido de botón
        GestorDeAudio.compartido.reproducirSonidoBoton()
        
        // Regresar
        dismiss(animated: true, completion: nil)
    }
}
