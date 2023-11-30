//
//  WantListDataPersistanceDataManager.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/27/23.
//

import Foundation

protocol WantListPersisting {
    func save(groupedList: [String: [WantedList]])
    func load() -> [String: [WantedList]]
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
    
    func save(groupedList: [String: [WantedList]]) {
        let encoder = PropertyListEncoder()
        let dataList = groupedList.map { WantedListGroup(key: $0.key, list: $0.value) }
        
        do {
            let data = try encoder.encode(dataList)
            try data.write(to: WantListDataPersistanceDataManager.wantedListFileURL, options: .atomic)
        } catch {
            // Handle the error here
            print("Error saving data: \(error)")
        }
    }
        
    func load() -> [String: [WantedList]] {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: WantListDataPersistanceDataManager.wantedListFileURL)
            let dataList = try decoder.decode([WantedListGroup].self, from: data)
            
            // Convert the array of WantedListGroup back to a dictionary
            var groupedList = [String: [WantedList]]()
            for group in dataList {
                groupedList[group.key] = group.list
            }
            
            return groupedList
            
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            return [:]
        }
    }
}
