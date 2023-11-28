//
//  TargetWhiskeyModel.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import Observation
import SwiftUI

@Observable
class WantedListLibrary {
    var dataPersistence: WantListPersisting

    var wantedLists = [WantedList]() {
        didSet {
            dataPersistence.save(wantedList: wantedLists)
        }
    }
    var userCreatedList = UserCreatedList()
    
    init(persistence: WantListPersisting = WantListDataPersistanceDataManager.shared, isForTesting: Bool = false) {
        dataPersistence = persistence
        
        if isForTesting {
            wantedLists = [
                WantedList(name: "Rye's", style: "Rye", description: "Ryes I want to try", whiskeys: [WhiskeyItem(name: "OF BP Rye")]),
                WantedList(name: "Rare Bourbons", style: "Bourbon", description: "Bourbons I would like to have", whiskeys: [WhiskeyItem(name: "Wild Turkey Generations")]),
                WantedList(name: "Super Rare", style: "Rye", description: "Super Rares", whiskeys: [WhiskeyItem(name: "High West MWND")])
            ]
        } else {
            wantedLists = []
        }
    }
    
    func deleteWantedWhiskey(whiskeyItem: WhiskeyItem) {
//        if let index = whiskeyItemsToAdd.firstIndex(where: {$0.id == whiskeyItem.id}) {
//            print("\(whiskeyItemsToAdd[index].id)  \(index)")
//        }
    }
    
    func addWantedList(userCreatedList: WantedList) {
        wantedLists.append(userCreatedList)
    }
    
    func addWhiskey() {
//        let trimmedName = whiskeyItem.name.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmedName.isEmpty else { return }
//        let whiskeyToAdd = WhiskeyItem(id: UUID(), name: trimmedName)
//        print(whiskeyToAdd.id)
//        whiskeyItemsToAdd.append(whiskeyToAdd)
//        whiskeyItem.name = ""
    }
    
    func save(wantedList: [WantedList]) {
        
    }
    
    func load() -> [WantedList] {
        return []
    }
}
