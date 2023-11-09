//
//  DataManager.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/24/23.
//

import Foundation

struct DataManager {
    
    static func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    static func save(data: Data, filename: String) -> Bool {
        let filepath = DataManager.getDocumentsDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: filepath, options: .atomic)
            return true
        } catch {
            print("Error saving data: \(error.localizedDescription)")
            return false
        }
    }
    
    static func load(filename: String) -> Data? {
        let filepath = DataManager.getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: filepath)
            return data
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            return nil
        }
    }
}
