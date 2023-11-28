//
//  WantListDataPersistanceDataManager.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/27/23.
//

import Foundation

protocol WantListPersisting {
    func save(wantedList: [WantedList])
    func load() -> [WantedList]
}

class WantListDataPersistanceDataManager: WantListPersisting {
    
    static let shared = WantListDataPersistanceDataManager()
    
    private init() {}
    
    static let documentsDirectoryURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    
    static var wantedListFileURL: URL {
        return documentsDirectoryURL.appendingPathComponent("wantList_data.plist")
    }
    
    func save(wantedList: [WantedList]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(wantedList)
            try data.write(to: WantListDataPersistanceDataManager.wantedListFileURL, options: .atomic)
        } catch {

        }
    }
    
    func load() -> [WantedList] {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: WantListDataPersistanceDataManager.wantedListFileURL)
            let wantedList = try decoder.decode([WantedList].self, from: data)
            save(wantedList: wantedList)
            return wantedList
    
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            return []
        }
        
    }
}
