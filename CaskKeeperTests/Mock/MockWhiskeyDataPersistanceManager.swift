//
//  MockWhiskeyDataPersistenceManager.swift
//  CaskKeeperTests
//
//  Created by Jon Oryhan on 12/6/23.
//
import SwiftUI
@testable import CaskKeeper

class MockWhiskeyDataPersistenceManager: WhiskeyPersisting {
    var loadIsCalled = false
    var saveIsCalled = false
    var shouldExportSuccessfully = true
    var shouldImportSuccessfully = true
    var shouldThrowLoadError = false
    
    let whiskey1ID = UUID(uuidString: "1ea050f2-1ab1-5e22-bc76-cb86520f4678")!
    let whiskey2ID = UUID(uuidString: "2ea050f2-1ab1-5e22-bc76-cb86520f4678")!

    func save(collection: [CaskKeeper.Whiskey]) {
       saveIsCalled = true
    }
    
    
    // Is called when isForTesting is false.
    func load() -> [CaskKeeper.Whiskey] {
        if shouldThrowLoadError {
            return []
        } else {
            loadIsCalled = true
            return [
                Whiskey(id: whiskey1ID, label: "TestLabel", bottle: "TestRye", purchasedDate: .now, image: UIImage(named: "whiskey1") ?? UIImage(), proof: 110.0, bottleState: .sealed, style: .bourbon, origin: .us, age: 8, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 56), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 78)]),
                Whiskey(id: whiskey2ID, label: "TestLabel1", bottle: "TestBourbon", purchasedDate: .now, image: UIImage(named: "whiskey1") ?? UIImage(), proof: 110.0, bottleState: .sealed, style: .bourbon, origin: .us, age: 8, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 56), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 78)])
            ]
        }
        
    }
    
    func exportCollectionToJson(collection: [CaskKeeper.Whiskey], completion: @escaping (Result<URL, Error>) -> Void) {
        if shouldExportSuccessfully {
            let mockURL = URL(fileURLWithPath: "path/to/mock/file.json")
            completion(.success(mockURL))
        } else {
            completion(.failure(NSError(domain: "", code: 1, userInfo: nil)))
        }
    }
    
    func importWhiskeyCollectionFromJSON(fileURL: URL, completion: @escaping (Result<[CaskKeeper.Whiskey], Error>) -> Void) {        
        if shouldImportSuccessfully {
            let whiskeys = [
                Whiskey(id: UUID(), label: "TestLabel", bottle: "TestRye", purchasedDate: .now, image: UIImage(named: "whiskey1") ?? UIImage(), proof: 110.0, bottleState: .sealed, style: .bourbon, origin: .us, age: 8, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 56), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 78)]),
                Whiskey(id: UUID(), label: "TestLabel1", bottle: "TestBourbon", purchasedDate: .now, image: UIImage(named: "whiskey1") ?? UIImage(), proof: 110.0, bottleState: .sealed, style: .bourbon, origin: .us, age: 8, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 56), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 78)])
            ]
            completion(.success(whiskeys))
        } else {
            completion(.failure(NSError(domain: "", code: 1, userInfo: nil)))
        }
    }
    
    func setupLoadForFailure() {
        shouldThrowLoadError = true
    }
}
