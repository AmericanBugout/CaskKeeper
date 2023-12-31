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
    
    var groupedLists: [WantedListGroup]?
    
    init(persistence: WantListPersisting = WantListDataPersistenceDataManager.shared, isForTesting: Bool = false) {
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
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
                             WhiskeyItem(name: "Willet Vintage 23 Old Rye Whiskey"),
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
            self.groupedLists = dataPersistence.load()
        }
    }
    
    func removeWhiskeyFromList(indexSet: IndexSet, groupIndex: Int, list: WantedList) {
        guard let groupedLists = self.groupedLists else { return }
        if let listIndex = groupedLists[groupIndex].list.firstIndex(where: {$0.id == list.id}) {
            groupedLists[groupIndex].list[listIndex].whiskeys.remove(atOffsets: indexSet)
        }
        
        self.groupedLists = groupedLists
        dataPersistence.save(groupedList: groupedLists)
    }
    
    func addWantedList() {
        let wantedList = WantedList(name: userCreatedList.name, style: userCreatedList.style.rawValue, description: userCreatedList.description, whiskeys: userCreatedList.whiskeys)
        let styleKey = wantedList.style
        
        if groupedLists == nil {
            groupedLists = [WantedListGroup]()
        }
        
        if let index = groupedLists?.firstIndex(where: {$0.key == styleKey }) {
            groupedLists?[index].list.append(wantedList)
        } else {
            let newGroupList = WantedListGroup(key: styleKey, list: [wantedList])
            groupedLists?.append(newGroupList)
        }
        
        dataPersistence.save(groupedList: groupedLists ?? [])
    }

    func deleteItem(groupIndex: Int, itemIndexSet: IndexSet) {
        guard var groupedLists = self.groupedLists else { return }
            groupedLists[groupIndex].list.remove(atOffsets: itemIndexSet)
            if groupedLists[groupIndex].list.isEmpty {
                groupedLists.remove(at: groupIndex)
            }
            self.groupedLists = groupedLists
            
            dataPersistence.save(groupedList: groupedLists)
    }
    
    func saveWhiskeyList(groupIndex: Int, list: WantedList) {
        guard var groupedLists = self.groupedLists else { return }
        if let listIndex = groupedLists[groupIndex].list.firstIndex(where: {$0.id == $0.id}) {
            groupedLists[groupIndex].list[listIndex] = list
            self.groupedLists = groupedLists
            dataPersistence.save(groupedList: groupedLists)
        }
    }

   
    func updateWhiskeysInList(groupIndex: Int, list: WantedList, whiskeysToSave: [WhiskeyItem]) {
        guard let groupedLists = self.groupedLists else { return }
        if let listIndex = groupedLists[groupIndex].list.firstIndex(where: {$0.id == list.id }) {
            groupedLists[groupIndex].list[listIndex].whiskeys = whiskeysToSave
            self.groupedLists = groupedLists
            dataPersistence.save(groupedList: groupedLists)
            print("Whiskeys have been updated in DetailView")
        }
    }
    
    func updatewhiskeyFromEditList(groupIndex: Int, list: WantedList, whiskey: WhiskeyItem) {
        guard let groupedLists = self.groupedLists else { return }
        if let listIndex = groupedLists[groupIndex].list.firstIndex(where: {$0.id == list.id }) {
            if let whiskeyIndex = groupedLists[groupIndex].list[listIndex].whiskeys.firstIndex(where: {$0.id == whiskey.id }) {
                groupedLists[groupIndex].list[listIndex].whiskeys[whiskeyIndex] = whiskey
                self.groupedLists = groupedLists
                dataPersistence.save(groupedList: groupedLists)
                print("Whiskey has been saved from the WhiskeyEditView")
            }
        }
    }
    
    func addWhiskeysToExistingList(list: WantedList, groupIndex: Int, savedWhiskeys: [WhiskeyItem]) {
        guard let groupedLists = self.groupedLists else { return }
        if let listIndex = groupedLists[groupIndex].list.firstIndex(where: {$0.id == list.id }) {
            groupedLists[groupIndex].list[listIndex].whiskeys.append(contentsOf: savedWhiskeys)
            self.groupedLists = groupedLists
            dataPersistence.save(groupedList: groupedLists)
        }
    }
    
    func loadList() {
        self.groupedLists = dataPersistence.load()
    }
    
    func fetchList(groupIndex: Int, list: WantedList) -> WantedList? {
        guard let groupedLists = self.groupedLists else { return nil }
        if let listIndex = groupedLists[groupIndex].list.firstIndex(where: {$0.id == list.id }) {
            return groupedLists[groupIndex].list[listIndex]
        }
        return nil
    }
}
