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
    var whiskeys = MockWhiskeyData.whiskeys
    
    let id1 = UUID(uuidString: "1ea050f2-1ab1-5e22-bc76-cb86520f4678")!
    let id2 = UUID(uuidString: "2ea050f2-1ab1-5e22-bc76-cb86520f4678")!
    
    var expectedResults: [Whiskey]?
    
    
    func save(collection: [CaskKeeper.Whiskey]) {
       saveIsCalled = true
    }
    
    
    // Is called when isForTesting is false.
    func load() -> [CaskKeeper.Whiskey] {
        if shouldThrowLoadError {
            return []
        } else {
            loadIsCalled = true
            whiskeys[0].id = id1
            whiskeys[1].id = id2
            return whiskeys
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


extension MockWhiskeyDataPersistenceManager {
    
    func loadMockWhiskeys(from resourceName: String, _ resourceExtension: String) -> [Whiskey] {
        let testBundle = Bundle(for: type(of: self))
        guard let url = testBundle.url(forResource: resourceName, withExtension: resourceExtension) else {
            fatalError("Unable to whiskeys from resource file.")
        }
        do {
            let data = try Data(contentsOf: url)
            let whiskeys = try JSONDecoder().decode([Whiskey].self, from: data)
            return whiskeys
        } catch {
            fatalError("Unable to decode whiskeys from \(resourceName).json")
        }
        
    }
    
}
