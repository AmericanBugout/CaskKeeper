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
    var ahouldSaveBeSuccessful = true
    var whiskeys = MockWhiskeyData.whiskeys
    
    let id1 = UUID(uuidString: "1ea050f2-1ab1-5e22-bc76-cb86520f4678")!
    let id2 = UUID(uuidString: "2ea050f2-1ab1-5e22-bc76-cb86520f4678")!
    
    let encoder: WhiskeyEncoding
    
    init(encoder: WhiskeyEncoding = PropertyListEncoderWrapper()) {
        self.encoder = encoder
    }
    
    
    func save(collection: [CaskKeeper.Whiskey]) throws {
        if ahouldSaveBeSuccessful {
            saveIsCalled = true
        } else {
            _ = try encoder.encode(collection)
        }
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
            completion(.failure(DataManagerError.exportFailed))
        }
    }
    
    func importWhiskeyCollectionFromJSON(fileURL: URL, completion: @escaping (Result<[CaskKeeper.Whiskey], Error>) -> Void) {        
        if shouldImportSuccessfully {
            completion(.success(MockWhiskeyData.whiskeys))
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
