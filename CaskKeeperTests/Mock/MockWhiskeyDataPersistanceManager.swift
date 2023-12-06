//
//  MockWhiskeyDataPersistanceManager.swift
//  CaskKeeperTests
//
//  Created by Jon Oryhan on 12/6/23.
//
import SwiftUI
@testable import CaskKeeper

class MockWhiskeyDataPersistanceManager: WhiskeyPersisting {
    var loadIsCalled = false
    var saveIsCalled = false
    
    func save(collection: [CaskKeeper.Whiskey]) {
       saveIsCalled = true
    }
    
    func load() -> [CaskKeeper.Whiskey] {
        loadIsCalled = true
        return [
            Whiskey(label: "TestLabel", bottle: "TestRye", purchasedDate: .now, image: UIImage(named: "whiskey1") ?? UIImage(), proof: 110.0, bottleState: .sealed, style: .bourbon, origin: .us, age: 8, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 56), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 78)]),
            Whiskey(label: "TestLabel1", bottle: "TestBourbon", purchasedDate: .now, image: UIImage(named: "whiskey1") ?? UIImage(), proof: 110.0, bottleState: .sealed, style: .bourbon, origin: .us, age: 8, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 56), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 78)])
        ]
    }
    
    func exportCollectionToJson(collection: [CaskKeeper.Whiskey], completion: @escaping (Result<URL, Error>) -> Void) {
    
    }
    
    func importWhiskeyCollectionFromJSON(fileURL: URL, completion: @escaping (Result<[CaskKeeper.Whiskey], Error>) -> Void) {
        
    }
    
    
}
