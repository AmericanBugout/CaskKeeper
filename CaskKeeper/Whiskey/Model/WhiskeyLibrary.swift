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
    
    var collection: [Whiskey] = [] {
        didSet {
            dataPersistenceManager.save(collection: collection)
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
    
    
    
    init(dataPersistence: WhiskeyPersisting = DataPersistenceManager.shared, isForTesting: Bool = false) {
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
    
    /* CRUD Operations */
   
    func addWhiskey(whiskey: Whiskey) {
        collection.append(whiskey)
    }
    
    func deleteAtIndex(index: IndexSet) {
        collection.remove(atOffsets: index)
    }
    
    func updateWhiskey(updatedWhiskey: Whiskey) {
        if let index = collection.firstIndex(where: {$0.id == updatedWhiskey.id}) {
            collection[index] = updatedWhiskey
        }
    }
    
    func updateImage(for whiskey: Whiskey, with imageData: Data?) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            collection[index].imageData = imageData
            dataPersistenceManager.save(collection: collection)
        }
    }
    
    func addWhiskeyTasting(for whiskey: Whiskey, tasting: Whiskey.Taste) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            collection[index].tastingNotes.append(tasting)
            dataPersistenceManager.save(collection: collection)
        }
    }
    
    func deleteTasting(whiskey: Whiskey, indexSet: IndexSet) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            let updateWhiskey = collection[index]
            updateWhiskey.tastingNotes.remove(atOffsets: indexSet)
            collection[index] = updateWhiskey
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
}
