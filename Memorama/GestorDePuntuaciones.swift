//
//  GestorDePuntuaciones.swift
//  Memorama
//
//  Created by Victor on 12/5/25.
//

import UIKit

class GestorDePuntuaciones: NSObject {
    
    // Singleton
    static let compartido = GestorDePuntuaciones()
    
    var records: [[String: Any]] = []
    
    private override init() {
        super.init()
        cargarRecords()
    }
    
    // Obtener la ruta del archivo plist en Documents
    func obtenerRutaArchivo() -> URL {
        let directorios = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let rutaDocumentos = directorios[0]
        return rutaDocumentos.appendingPathComponent("records.plist")
    }
    
    // Cargar récords desde el archivo
    func cargarRecords() {
        let rutaArchivo = obtenerRutaArchivo()
        
        if FileManager.default.fileExists(atPath: rutaArchivo.path) {
            // El archivo existe, cargarlo
            if let datos = try? Data(contentsOf: rutaArchivo),
               let recordsCargados = try? PropertyListSerialization.propertyList(from: datos, options: [], format: nil) as? [[String: Any]] {
                records = recordsCargados
            }
        } else {
            // El archivo no existe, crear récords falsos
            crearRecordsFalsos()
        }
    }
    
    // Crear 5 récords falsos iniciales
    func crearRecordsFalsos() {
        records = [
            ["nombre": "Bot 1", "puntos": 100],
            ["nombre": "Bot 2", "puntos": 80],
            ["nombre": "Bot 3", "puntos": 60],
            ["nombre": "Bot 4", "puntos": 40],
            ["nombre": "Bot 5", "puntos": 20]
        ]
        guardarArchivo()
    }
    
    // Guardar récords en el archivo
    func guardarArchivo() {
        let rutaArchivo = obtenerRutaArchivo()
        
        if let datos = try? PropertyListSerialization.data(fromPropertyList: records, format: .xml, options: 0) {
            try? datos.write(to: rutaArchivo)
        }
    }
    
    // Verificar si un puntaje entra en el Top 5
    func esRecord(puntos: Int) -> Bool {
        if records.count < 5 {
            return true
        }
        
        if let puntosMinimos = records.last?["puntos"] as? Int {
            return puntos > puntosMinimos
        }
        
        return false
    }
    
    // Guardar un nuevo récord si entra en el Top 5
    func guardarRecord(nombre: String, puntos: Int) {
        // Agregar el nuevo récord
        let nuevoRecord: [String: Any] = ["nombre": nombre, "puntos": puntos]
        records.append(nuevoRecord)
        
        // Ordenar de mayor a menor por puntos
        records.sort { (record1, record2) -> Bool in
            let puntos1 = record1["puntos"] as? Int ?? 0
            let puntos2 = record2["puntos"] as? Int ?? 0
            return puntos1 > puntos2
        }
        
        // Mantener solo los primeros 5
        if records.count > 5 {
            records = Array(records.prefix(5))
        }
        
        // Guardar en el archivo
        guardarArchivo()
    }
    
    // Obtener todos los récords
    func obtenerRecords() -> [[String: Any]] {
        return records
    }
}
