//
//  WhiskeyModel.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import UIKit
import Observation

@Observable
class WhiskeyLibrary {
    
    var collection: [Whiskey] = [] {
        didSet {
            save()
        }
    }
    
    var collectionCount: Int { return collection.count }
    
    init(isForTesting: Bool = false) {
        if isForTesting {
            collection = [
                Whiskey(label: "Hammered", bottle: "Straight Rye", purchasedDate: .now, image: UIImage(named: "whiskey1") ?? UIImage(), proof: 110.0, style: .bourbon, origin: .us, age: .eight, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 87), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 88)]),
                Whiskey(label: "Big Tower Whiskey", bottle: "8 Year Reserve", purchasedDate: .now, image: UIImage(named: "whiskey2") ?? UIImage(), proof: 111.2, style: .rye, origin: .us, age: .eight, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Strong Oak. Fruity. Not sure I would buy again at the price point", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Fruity")], score: 78)]),
                Whiskey(label: "Rattle Creek", bottle: "Straight Bourbon", purchasedDate: .now, image: UIImage(named: "whiskey3") ?? UIImage() , proof: 131.2, style: .bourbon, origin: .us, age: .twelve,tastingNotes:  [Whiskey.Taste(date: Date(), customNotes: "Wonder viscosity, Bold Flavor and smell", notes: [Flavor(name: "Honey"), Flavor(name: "Toast"), Flavor(name: "Cherry Coke")], score: 97)]),
                Whiskey(label: "Small Reserve", bottle: "Single Barrel", purchasedDate: .now, image: UIImage(named: "whiskey4") ?? UIImage(), proof: 111.3, style: .bourbon, origin: .us, age: .six, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Nothing special", notes: [Flavor(name: "Vanilla"), Flavor(name: "Caramel"), Flavor(name: "Wheat")], score: 77)])
            ]
        } else {
            collection = load()
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
            save()
        }
    }
    
    func addWhiskeyTasting(for whiskey: Whiskey, tasting: Whiskey.Taste) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            collection[index].tastingNotes.append(tasting)
            save()
        }
    }
    
    func deleteTasting(whiskey: Whiskey, indexSet: IndexSet) {
        if let index = collection.firstIndex(where: {$0.id == whiskey.id}) {
            let updateWhiskey = collection[index]
            updateWhiskey.tastingNotes.remove(atOffsets: indexSet)
            collection[index] = updateWhiskey
        }
    }
    
    /* Save and load whiskey */
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(collection)
            if DataManager.save(data: data, filename: "whiskeyCollection") {
                print("Data was saved.")
            } else {
                print("Unable to save data")
            }
        } catch {
            print("Error saving data.")
        }
    }
    
    func load() -> [Whiskey] {
        guard let data = DataManager.load(filename: "whiskeyCollection") else {
            return []
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode([Whiskey].self, from: data)
        } catch {
            print("Unable to deoode Data: \(error.localizedDescription)")
            return []
        }
    }
}
