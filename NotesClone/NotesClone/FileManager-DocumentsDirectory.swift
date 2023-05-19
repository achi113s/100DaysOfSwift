//
//  FileManager-DocumentsDirectory.swift
//  NotesClone
//
//  Created by Giorgio Latour on 5/17/23.
//

import UIKit
import UniformTypeIdentifiers

extension FileManager {
    static var documentsDirectory: URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    static var notesSavePath = FileManager.documentsDirectory.appendingPathComponent("SavedNotes")
    
    func decode<T: Decodable>(_ file: String, encodingType: UTType) -> T {
        guard let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(file, conformingTo: encodingType)) else {
            fatalError("Failed to load \(file) from Documents.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from Documents.")
        }
        
        return loaded
    }
}

