//
//  DataManager.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/24/23.
//

import Foundation

enum DataManagerError: Error, LocalizedError {
    case encodingFailed
    
    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return NSLocalizedString("Encoding Failed:", comment: "")
        }
    }
}

protocol WhiskeyPersisting {
    func save(collection: [Whiskey]) throws
    func load() -> [Whiskey]
    func exportCollectionToJson(collection: [Whiskey], completion: @escaping (Result<URL, Error>) -> Void)
    func importWhiskeyCollectionFromJSON(fileURL: URL, completion: @escaping (Result<[Whiskey], Error>) -> Void )
}

class WhiskeyDataPersistenceManager: WhiskeyPersisting {
    
    static let shared = WhiskeyDataPersistenceManager()
    
    private init() {}
    
    static let documentsDirectoryURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    
    static var collectionsFileURL: URL {
        return documentsDirectoryURL.appendingPathComponent("collection_data.plist")
    }
    
    
    func save(collection: [Whiskey]) throws {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(collection)
            try data.write(to: WhiskeyDataPersistenceManager.collectionsFileURL, options: .atomic)
        } catch {
            throw DataManagerError.encodingFailed
        }
    }
    
    func load() -> [Whiskey] {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: WhiskeyDataPersistenceManager.collectionsFileURL)
            print(String(data: data, encoding: .utf8) ?? "")
            let collection = try decoder.decode([Whiskey].self, from: data)
            try save(collection: collection)
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
                let fileURL = WhiskeyDataPersistenceManager.documentsDirectoryURL.appendingPathComponent(fileName)
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
            let collection = try decoder.decode([Whiskey].self, from: jsonWhiskeyData)
            completion(.success(collection))
        } catch {
            completion(.failure(error))
        }
    }
    

}
