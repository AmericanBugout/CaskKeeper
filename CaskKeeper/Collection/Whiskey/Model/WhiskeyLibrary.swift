//
//  WhiskeyModel.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI
import Observation

@Observable
class WhiskeyLibrary {
    var dataPersistenceManager: WhiskeyPersisting
    
    var duplicateWhiskeyCountOnJSONImport: Int?
    
    var importedWhiskeyCount: Int?
    
    var collection = [Whiskey]() {
        didSet {
            do {
                try dataPersistenceManager.save(collection: collection)
            } catch {
                print("Error Saving: \(error.localizedDescription)")
            }
        }
    }
    
    var filteredWhiskeys: [Whiskey] = []
    
    var currentFilter: FilterState = .all {
        didSet {
            filterWhiskey(state: currentFilter)
        }
    }
    
    init(dataPersistence: WhiskeyPersisting = WhiskeyDataPersistenceManager.shared, isForTesting: Bool = false) {
        dataPersistenceManager = dataPersistence
        
        if isForTesting {
            collection = [
                Whiskey(label: "Hammered", bottle: "Straight Rye", purchasedDate: .now, image: UIImage(named: "whiskey1") ?? UIImage(), proof: 110.0, bottleState: .sealed, style: .bourbon, origin: .us, age: 8, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 56), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 78)]),
                Whiskey(label: "Big Tower Whiskey", bottle: "8 Year Reserve", purchasedDate: .now, image: UIImage(named: "whiskey2") ?? UIImage(), proof: 111.2, bottleState: .finished, style: .rye, origin: .us, age: 12.5, price: 68.99, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Strong Oak. Fruity. Not sure I would buy again at the price point", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Fruity")], score: 78)]),
                Whiskey(label: "Rattle Creek", bottle: "Straight Bourbon", purchasedDate: .now, image: UIImage(named: "whiskey3") ?? UIImage() , proof: 131.2, bottleState: .opened, style: .bourbon, origin: .us, age: 6, price: 89.33, tastingNotes:  [Whiskey.Taste(date: Date(), customNotes: "Wonder viscosity, Bold Flavor and smell", notes: [Flavor(name: "Honey"), Flavor(name: "Toast"), Flavor(name: "Cherry Coke")], score: 97)]),
                Whiskey(label: "Small Reserve", bottle: "Single Barrel", purchasedDate: .now, image: UIImage(named: "whiskey4") ?? UIImage(), proof: 111.3, bottleState: .opened, style: .bourbon, origin: .us, age: 8, price: 33.44, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Nothing special", notes: [Flavor(name: "Vanilla"), Flavor(name: "Caramel"), Flavor(name: "Wheat")], score: 77)])
            ]
        } else {
            collection = dataPersistence.load()
            filterWhiskey(state: currentFilter)
            sortCollection()
        }
    }
    
    func addWhiskey(whiskey: Whiskey) {
        collection.append(whiskey)
        filterWhiskey(state: currentFilter)
        sortCollection()
    }
    
    func deleteAtIndex(index: IndexSet) {
        withAnimation(Animation.smooth) {
            collection.remove(atOffsets: index)
            sortCollection()
            filterWhiskey(state: currentFilter)
        }
    }
    
    func updateWhiskey(updatedWhiskey: Whiskey) {
        if let index = collection.firstIndex(where: {$0.id == updatedWhiskey.id}) {
            collection[index] = updatedWhiskey
        }
    }
    
    func updateImage(for whiskey: Whiskey, with imageData: Data?) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            collection[index].imageData = imageData
            do {
                try dataPersistenceManager.save(collection: collection)
            } catch {
                print("Error Saving: \(error.localizedDescription)")
            }
        }
    }
    
    func addWhiskeyTasting(for whiskey: Whiskey, tasting: Whiskey.Taste) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            collection[index].tastingNotes.append(tasting)
            do {
                try dataPersistenceManager.save(collection: collection)
            } catch {
                print("Error Saving: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTasting(whiskey: Whiskey, indexSet: IndexSet) {
        if let index = self.collection.firstIndex(where: {$0.id == whiskey.id}) {
            let updateWhiskey = self.collection[index]
            updateWhiskey.tastingNotes.remove(atOffsets: indexSet)
            self.collection[index] = updateWhiskey
        }
        
    }
    
    func updateWhiskeyToFinished(whiskey: Whiskey) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            collection[index].bottleFinished = true
            collection[index].opened = false
            collection[index].bottleState = .finished
            collection[index].consumedDate = Date()
        }
    }
    
    func updateOpenedDate(whiskey: Whiskey) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            collection[index].dateOpened = Date()
            collection[index].bottleState = .opened
            collection[index].firstOpen = false
        }
    }
    
    func exportWhiskeyCollectionAsJSON(completion: @escaping (Result<URL, Error>) -> Void) {
        do {
            try dataPersistenceManager.exportCollectionToJson(collection: collection, completion: completion)
        } catch {
            
        }
    }
    
    func importWhiskeyCollectionFromJSON(fileURL: URL, completion: @escaping (Result<[Whiskey], Error>) -> Void ) {
        dataPersistenceManager.importWhiskeyCollectionFromJSON(fileURL: fileURL, completion: completion)
    }
    
    func processImportedWhiskeys(importedWhiskeys: [Whiskey]) {
        var newWhiskeys: [Whiskey] = []
        var duplicateCount = 0
        
        for whiskey in importedWhiskeys {
            if self.collection.contains(where: { $0.id == whiskey.id }) {
                duplicateCount += 1
            } else {
                let updatedWhiskey = whiskey
                if whiskey.bottleState == .opened {
                    updatedWhiskey.opened = true
                    updatedWhiskey.firstOpen = false
                }
                newWhiskeys.append(updatedWhiskey)
            }
        }
        
        DispatchQueue.main.async {
            self.collection.append(contentsOf: newWhiskeys)
            self.sortCollection()
            self.importedWhiskeyCount = (self.importedWhiskeyCount ?? 0) + newWhiskeys.count
            self.duplicateWhiskeyCountOnJSONImport = (self.duplicateWhiskeyCountOnJSONImport ?? 0) + duplicateCount
        }
    }
    
    func setCountsToNil() {
        self.importedWhiskeyCount = nil
        self.duplicateWhiskeyCountOnJSONImport = nil
    }
    
    func sortCollection() {
        collection.sort(by: { $0.label < $1.label })
        filterWhiskey(state: currentFilter)
    }
    
    func filterWhiskey(state: FilterState) {
        switch state {
        case .all:
            filteredWhiskeys = collection.sorted(by: {$0.label < $1.label})
        case .opened:
            filteredWhiskeys = collection.filter({$0.bottleState == .opened})
        case .sealed:
            filteredWhiskeys = collection.filter({$0.bottleState == .sealed})
        case .finished:
            filteredWhiskeys = collection.filter({$0.bottleState == .finished})
        }
    }
    
    func getRandomWhiskey(state: FilterState) -> (label: String, bottle: String)? {
        let filteredWhiskeys: [Whiskey]
        
        switch state {
        case .all:
            filteredWhiskeys = collection.sorted(by: { $0.label < $1.label })
        case .opened:
            filteredWhiskeys = collection.filter { $0.bottleState == .opened }
        case .sealed:
            filteredWhiskeys = collection.filter { $0.bottleState == .sealed }
        case .finished:
            filteredWhiskeys = collection.filter { $0.bottleState == .finished }
        }
        
        // If there are whiskeys in the filtered list, return a random one's label and bottle state
        if !filteredWhiskeys.isEmpty {
            let randomIndex = Int.random(in: 0..<filteredWhiskeys.count)
            return (filteredWhiskeys[randomIndex].label, filteredWhiskeys[randomIndex].bottle)
        }
        
        // If no whiskeys match the filter, return nil
        return nil
    }
}


extension WhiskeyLibrary {
    
    var collectionCount: Int { return collection.count }
    
    var sealedCount: Int {
        collection.filter { whiskey in
            whiskey.bottleState == .sealed
        }.count
    }
    
    var openedCount: Int {
        collection.filter { whiskey in
            whiskey.bottleState == .opened
        }.count
    }
    
    var finishedCount: Int {
        collection.filter { whiskey in
            whiskey.bottleState == .finished
        }
        .count
    }
    
    var avgProof: Double {
        let totalProof = collection.reduce(0, {$0 + $1.proof})
        return !collection.isEmpty ? Double(totalProof) / Double(collectionCount) : 0.0
    }
    
    var avgAge: Double {
        let validItems = collection.filter { $0.age != nil && $0.age ?? 0 > 0 }
        let totalAge = validItems.reduce(0, { $0 + ($1.age ?? 0) })
        return !validItems.isEmpty ? Double(totalAge) / Double(validItems.count) : 0.0
    }
    
    var mostExpensiveWhiskey: Whiskey? {
        return collection.max { ($0.price ?? 0) < ($1.price ?? 0) }
    }
    
    var leastExpensiveWhiskey: Whiskey? {
        return collection
            .filter { ($0.price ?? 0) > 0 }
            .min { ($0.price ?? 0) < ($1.price ?? 0) }
    }
    
    var highestRated: Whiskey? {
        return collection
            .filter { $0.avgScore > 0 }
            .max { $0.avgScore < $1.avgScore }
    }
    
    var mostTastes: Whiskey? {
        return collection
            .filter { $0.tastingNotes.count > 0 }
            .max { $0.tastingNotes.count < $1.tastingNotes.count}
    }
    
    var longestOpen: Whiskey? {
        return collection
            .filter { $0.dateOpened != nil }
            .sorted {
                guard let dateOpened1 = $0.dateOpened, let dateOpened2 = $1.dateOpened else {
                    return false
                }
                return dateOpened1 < dateOpened2
            }
            .first
    }
    
}
