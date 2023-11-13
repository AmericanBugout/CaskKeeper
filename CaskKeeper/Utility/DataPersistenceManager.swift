//
//  DataManager.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/24/23.
//

import Foundation

protocol WhiskeyPersisting {
    func save(collection: [Whiskey])
    func load() -> [Whiskey]
}

class DataPersistenceManager: WhiskeyPersisting {
    
    static let shared = DataPersistenceManager()
    
    private init() {}
    
    static let documentsDirectoryURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    
    static var collectionsFileURL: URL {
        return documentsDirectoryURL.appendingPathComponent("collection.plist")
    }
    
    
    func save(collection: [Whiskey]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(collection)
            try data.write(to: DataPersistenceManager.collectionsFileURL, options: .atomic)
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    func load() -> [Whiskey] {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: DataPersistenceManager.collectionsFileURL)
            let collection = try decoder.decode([Whiskey].self, from: data)
            return collection
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            return []
        }
    }
}
