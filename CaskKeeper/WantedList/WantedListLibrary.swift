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

    var userCreatedList = UserCreatedList()
    
    var groupedLists: [String: [WantedList]]?
    
    init(persistence: WantListPersisting = WantListDataPersistanceDataManager.shared, isForTesting: Bool = true) {
        dataPersistence = persistence
        
        if isForTesting {
            let superryes = [
                WantedList(name: "Rye's", style: "Rye", description: "ryes I want to try", whiskeys: [WhiskeyItem(name: "High West MWND"), WhiskeyItem(name: "High West")]),
                WantedList(name: "Super Rare", style: "Rye", description: "Super Rares", whiskeys: [WhiskeyItem(name: "Woodford Reserver double Rye")])
            ]
            let bourbon = [WantedList(name: "Somewhat rare", style: "Bourbon", description: "Not so hard to come bys", whiskeys: [WhiskeyItem(name: "Wild Turkey Generations")])]
            groupedLists = ["Rye": superryes, "Bourbon": bourbon]
            
        } else {
            groupedLists = nil
        }
    }
    
    func updateWhiskey(whiskey: WhiskeyItem, inList listId: UUID) {
        for (style, lists) in groupedLists ?? [:] {
            if let listIndex = lists.firstIndex(where: {$0.id == listId}) {
                var list = lists[listIndex]
                if let whiskeyIndex = list.whiskeys?.firstIndex(where: {$0.id == whiskey.id}) {
                    list.whiskeys?[whiskeyIndex] = whiskey
                    groupedLists?[style]?[listIndex] = list
                    
                    //dataPersistence.save(groupedLists: groupedLists)
                }
                break
            }
        }
    }

    func addWantedList() {
        let wantedList = WantedList(name: userCreatedList.name, style: userCreatedList.style.rawValue, description: userCreatedList.description, whiskeys: userCreatedList.whiskeys)
        let styleKey = wantedList.style
        
        if groupedLists == nil {
            groupedLists = [String: [WantedList]]()
        }
        groupedLists?[styleKey, default: []].append(wantedList)
        //dataPersistence.save(groupedLists: groupedLists)
    }
    
    func modfiedWhiskeySearchList(wantedWhiskeys: [WhiskeyItem], foundWhiskeys: [WhiskeyItem]) {
        
    }
}
