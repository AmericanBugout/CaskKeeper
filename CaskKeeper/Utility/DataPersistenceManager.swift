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
    func exportCollectionToJson(collection: [Whiskey], completion: @escaping (Result<URL, Error>) -> Void)
    func importWhiskeyCollectionFromJSON(fileURL: URL, completion: @escaping (Result<[Whiskey], Error>) -> Void )
}

class DataPersistenceManager: WhiskeyPersisting {
    
    static let shared = DataPersistenceManager()
    
    private init() {}
    
    static let documentsDirectoryURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    
    static var collectionsFileURL: URL {
        return documentsDirectoryURL.appendingPathComponent("collection_data.plist")
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
            print(String(data: data, encoding: .utf8) ?? "")
            let collection = try decoder.decode([Whiskey].self, from: data)
            save(collection: collection)
            return collection
    
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            return []
        }
    }
    
    func exportCollectionToJson(collection: [Whiskey], completion: @escaping (Result<URL, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
              let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(collection)
                let fileName = "collection.json"
                let fileURL = DataPersistenceManager.documentsDirectoryURL.appendingPathComponent(fileName)
                try jsonData.write(to: fileURL, options: .atomicWrite)
                DispatchQueue.main.async {
                    completion(.success(fileURL))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func importWhiskeyCollectionFromJSON(fileURL: URL, completion: @escaping (Result<[Whiskey], Error>) -> Void ) {
        do {
            let jsonWhiskeyData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d/yyyy"
            
            if let whiskeyData = String(data: jsonWhiskeyData, encoding: .utf8) {
                print(whiskeyData)
            }
            let collection = try decoder.decode([Whiskey].self, from: jsonWhiskeyData)
            completion(.success(collection))
        } catch {
            completion(.failure(error))
        }
    }
}
