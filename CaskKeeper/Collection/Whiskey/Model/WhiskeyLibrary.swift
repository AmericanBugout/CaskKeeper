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
        }
    }
    
    func addWhiskey(whiskey: Whiskey) {
        collection.append(whiskey)
    }
    
    func deleteAtIndex(index: IndexSet) {
        withAnimation(Animation.smooth) {
            collection.remove(atOffsets: index)
            sortCollection()
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
        dataPersistenceManager.exportCollectionToJson(collection: collection, completion: completion)
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
    }
    
}
