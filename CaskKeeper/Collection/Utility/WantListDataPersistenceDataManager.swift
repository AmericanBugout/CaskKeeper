//
//  WantListDataPersistenceDataManager.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/27/23.
//

import Foundation

protocol WantListPersisting {
    func save(groupedList: [WantedListGroup])
    func load() -> [WantedListGroup]
}

class WantListDataPersistenceDataManager: WantListPersisting {
    
    static let shared = WantListDataPersistenceDataManager()
    
    private init() {}
    
    static let documentsDirectoryURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    
    static var wantedListFileURL: URL {
        return documentsDirectoryURL.appendingPathComponent("wantList_data.plist")
    }
    
    func save(groupedList: [WantedListGroup]) {
        let encoder = PropertyListEncoder()
        let dataList = groupedList.map { WantedListGroup(key: $0.key, list: $0.list) }
        
        do {
            let data = try encoder.encode(dataList)
            try data.write(to: WantListDataPersistenceDataManager.wantedListFileURL, options: .atomic)
            print("Saved Wanted List.")
        } catch {
            print("Error saving data: \(error)")
        }
    }
        
    func load() -> [WantedListGroup] {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: WantListDataPersistenceDataManager.wantedListFileURL)
            let dataList = try decoder.decode([WantedListGroup].self, from: data)
            print("Loaded Wanted List.")
            return dataList
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            return []
        }
    }
}
