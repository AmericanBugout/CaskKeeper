//
//  TargetWhiskeyModel.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import Observation
import SwiftUI

struct WantedListGroup: Codable {
    var key: String
    var list: [WantedList]
}

@Observable
class WantedListLibrary {
    var dataPersistence: WantListPersisting

    var userCreatedList = UserCreatedList()
    
    var groupedLists: [WantedListGroup]? {
        didSet {
            dataPersistence.save(groupedList: groupedLists ?? [])
        }
    }
    
    init(persistence: WantListPersisting = WantListDataPersistanceDataManager.shared, isForTesting: Bool = false) {
        dataPersistence = persistence
        
        if isForTesting {
            let ryes = [
                WantedList(name: "Most Expensive", style: "Rye", description: "I will probably never get these", whiskeys:
                            [WhiskeyItem(name: "Le Nell Red Hook Straight Rye Whiskey"),
                             WhiskeyItem(name: "Willett Family Estate Bottled Single-Barrel 22 Year Old Rye Whiskey"),
                             WhiskeyItem(name: "Rittenhouse Very Rare Single Barrel 25 Year Old Straight Rye Whisky"),
                             WhiskeyItem(name: "Colonel E.H. Taylor Straight Rye Whiskey")]),
                WantedList(name: "Might get these sometimes", style: "Rye", description: nil, whiskeys: 
                            [WhiskeyItem(name: "Redemption Barrel Proof Straight Rye Whiskey"),
                             WhiskeyItem(name: "WhistlePig 'The Boss Hog VII Magellan's Atlantic' Straight Rye Whiskey"),
                             WhiskeyItem(name: "Hirsch Selection 25 Year Old Kentucky Straight Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Redemption Barrel Proof Straight Rye Whiskey")])
                ]
            
            let bourbons = [WantedList(name: "Somewhat rare", style: "Bourbon", description: "Not so hard to come by", whiskeys: [
                WhiskeyItem(name: "Wild Turkey Generations"),
                WhiskeyItem(name: "RR Nelson Camp F"),
                WhiskeyItem(name: "Blanton's"),
                WhiskeyItem(name: "E.H. Taylor Single Barrel"),
                WhiskeyItem(name: "Stagg"),
            
            ])]
            groupedLists = [WantedListGroup(key: "Rye", list: ryes), WantedListGroup(key: "Bourbon", list: bourbons)]
            
        } else {
            groupedLists = dataPersistence.load()
        }
    }
    
    func updateWhiskey(whiskey: WhiskeyItem, inList listId: UUID) {
        guard var groupedLists = self.groupedLists else { return }

        for i in 0..<groupedLists.count {
            if let listIndex = groupedLists[i].list.firstIndex(where: { $0.id == listId }) {
                var list = groupedLists[i].list[listIndex]

                switch whiskey.state {
                case .found:
                    if let whiskeyIndex = list.whiskeys?.firstIndex(where: { $0.id == whiskey.id }) {
                        list.foundWhiskeys = list.foundWhiskeys ?? []
                        list.foundWhiskeys?.append(whiskey)
                        list.whiskeys?.remove(at: whiskeyIndex)
                    }

                case .looking:
                    // Move from 'foundWhiskeys' to 'whiskeys'
                    if let whiskeyIndex = list.foundWhiskeys?.firstIndex(where: { $0.id == whiskey.id }) {
                        list.whiskeys = list.whiskeys ?? []
                        list.whiskeys?.append(whiskey)
                        list.foundWhiskeys?.remove(at: whiskeyIndex)
                    }
                }
                groupedLists[i].list[listIndex] = list
            }
        }

        self.groupedLists = groupedLists
    }

    func addWantedList() {
        let wantedList = WantedList(name: userCreatedList.name, style: userCreatedList.style.rawValue, description: userCreatedList.description, whiskeys: userCreatedList.whiskeys)
        let styleKey = wantedList.style
        
        if groupedLists == nil {
            groupedLists = [WantedListGroup]()
        }
        
        if let index = groupedLists?.firstIndex(where: {$0.key == styleKey }) {
            groupedLists?[index].list.append(wantedList)
            dataPersistence.save(groupedList: groupedLists ?? [])
        } else {
            let newGroupList = WantedListGroup(key: styleKey, list: [wantedList])
            groupedLists?.append(newGroupList)
            dataPersistence.save(groupedList: groupedLists ?? [])
        }
    }
}
