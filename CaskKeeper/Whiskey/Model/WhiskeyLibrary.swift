//
//  WhiskeyModel.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import UIKit
import SwiftUI

class WhiskeyLibrary: ObservableObject {
    
    @Published var collection: [Whiskey] = [] {
        didSet {
            save()
        }
    }
    
    var collectionCount: Int { return collection.count }
    
    init(isForTesting: Bool = false) {
        if isForTesting {
            collection = [
                Whiskey(label: "Pikesville", bottle: "Straight Rye", purchasedDate: .now, image: UIImage(named: "pikes") ?? UIImage(), proof: 110.0, style: .rye, origin: .us, age: .six),
                Whiskey(label: "Sagamore", bottle: "8 Year Reserver", purchasedDate: .now, image: UIImage(named: "sagamore") ?? UIImage(), proof: 111.2, style: .rye, origin: .us, age: .eight),
                Whiskey(label: "Knob Creek", bottle: "Straight Bourbon", purchasedDate: .now, image: UIImage(named: "kc12") ?? UIImage() , proof: 131.2, style: .bourbon, origin: .us, age: .twelve),
                Whiskey(label: "Jefferson Reserve", bottle: "Jefferson Reserve", purchasedDate: .now, image: UIImage(named: "jeffersons") ?? UIImage(), proof: 111.3, style: .bourbon, origin: .us, age: .six)
            ]
        } else {
            collection = load()
        }
    }
   
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
            var updateWhiskey = collection[index]
            updateWhiskey.tastingNotes.remove(atOffsets: indexSet)
            collection[index] = updateWhiskey
        }
    }
    
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
