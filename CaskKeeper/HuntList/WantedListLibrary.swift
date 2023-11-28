//
//  TargetWhiskeyModel.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import Observation
import SwiftUI

@Observable
final class WantedListLibrary {
    var dataPersistence: WantListPersisting
    var userCreatedList = UserCreatedList()
    var whiskeyItem = WhiskeyItem()
    var whiskeyItemsToAdd: [WhiskeyItem] = []


    var wantedLists = [WantedList]() {
        didSet {
            dataPersistence.save(wantedList: wantedLists)
        }
    }
    
    init(persistence: WantListPersisting = WantListDataPersistanceDataManager.shared, isForTesting: Bool = false) {
        dataPersistence = persistence
        
        if isForTesting {
            wantedLists = [
               
            ]
        } else {
            wantedLists = []
        }
    }
    
    func deleteWantedWhiskey(whiskeyItem: WhiskeyItem) {
        if let index = whiskeyItemsToAdd.firstIndex(where: {$0.id == whiskeyItem.id}) {
            
            DispatchQueue.main.async {
                self.whiskeyItemsToAdd.remove(at: index)
            }
        }
    }
    
    func addWhiskey() {
        let trimmedName = whiskeyItem.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        let whiskeyToAdd = WhiskeyItem(id: UUID(), name: trimmedName)
        print(whiskeyToAdd.id)
        whiskeyItemsToAdd.append(whiskeyToAdd)
        whiskeyItem.name = ""
    }
    
    func save(wantedList: [WantedList]) {
        
    }
    
    func load() -> [WantedList] {
        return []
    }
}
