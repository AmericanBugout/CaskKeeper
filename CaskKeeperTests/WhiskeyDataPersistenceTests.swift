//
//  WhiskeyDataPersistenceTests.swift
//  CaskKeeperTests
//
//  Created by Jon Oryhan on 12/6/23.
//

import XCTest
@testable import CaskKeeper

final class WhiskeyDataPersistenceTests: XCTestCase {
    var whiskeyLibrary: WhiskeyLibrary!
    var dataPersistenceManager: MockWhiskeyDataPersistenceManager!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        dataPersistenceManager = MockWhiskeyDataPersistenceManager()
        whiskeyLibrary = WhiskeyLibrary(dataPersistence: dataPersistenceManager, isForTesting: false)
    }
    
    override func tearDownWithError() throws {
        whiskeyLibrary = nil
        dataPersistenceManager = nil
        try super.tearDownWithError()
    }
    
    func testSave() {
        dataPersistenceManager.ahouldSaveBeSuccessful = true
        XCTAssertTrue(dataPersistenceManager.saveIsCalled)
        
        dataPersistenceManager = MockWhiskeyDataPersistenceManager(encoder: MockFailingEncoder())
        dataPersistenceManager.ahouldSaveBeSuccessful = false
        
        XCTAssertThrowsError(try dataPersistenceManager.save(collection: MockWhiskeyData.whiskeys)) { error in
            guard let dataManagerError = error as? DataManagerError else {
                return XCTFail("Expected DataManagerError, but received different error type")
            }
            XCTAssertEqual(dataManagerError.localizedDescription, "Encoding Failed:")
        }
    }
    
    func testLoad() {
       XCTAssertEqual(dataPersistenceManager.load().count, 2, "Count should be 2")
        
       dataPersistenceManager.whiskeys.removeAll()
       dataPersistenceManager.setupLoadForFailure()
       XCTAssertTrue(dataPersistenceManager.load().isEmpty, "Loaded whiskeys should be empty error occurred.")
    }
    
    
    func testExportCollectionToJson() {
        let mockWhiskeyCollection: [Whiskey] = MockWhiskeyData.whiskeys

        dataPersistenceManager.shouldExportSuccessfully = true
        dataPersistenceManager.exportCollectionToJson(collection: mockWhiskeyCollection) { result in
            switch result {
            case .success(let url):
                XCTAssert(url.path.contains("path/to/mock/file.json"))
                // Add more assertions as needed
            case .failure(let error):
                XCTFail("Export failed with error: \(error)")
            }
        }

        dataPersistenceManager.shouldExportSuccessfully = false
        dataPersistenceManager.exportCollectionToJson(collection: mockWhiskeyCollection) { result in
            switch result {
            case .success:
                XCTFail("Export should have failed")
            case .failure(let error):
                XCTAssert(error is DataManagerError)
            }
        }
    }
}

