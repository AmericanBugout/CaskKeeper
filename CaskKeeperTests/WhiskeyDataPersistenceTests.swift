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
    
    func testExportFailed() {
        dataPersistenceManager.shouldExportSuccessfully = false
        
    }
    
    /* Data persitence tests */
    func testDataPersistenceFailedTest() {
        dataPersistenceManager.setupLoadForFailure()
        let loadedWhiskeys = dataPersistenceManager.load()
        XCTAssertTrue(loadedWhiskeys.isEmpty, "Loaded whiskeys should be empty error occurred.")
    }
    
    func testSaveWithEncodingFailure() {
        let mockEncoder = MockFailingEncoder()
        dataPersistenceManager = MockWhiskeyDataPersistenceManager(encoder: mockEncoder)
        let whiskeyCollection: [Whiskey] = MockWhiskeyData.whiskeys
        
        XCTAssertThrowsError(try dataPersistenceManager.save(collection: whiskeyCollection)) { error in
            guard let dataManagerError = error as? DataManagerError else {
                return XCTFail("Expected DataManagerError, but received different error type")
            }
            XCTAssertEqual(dataManagerError.localizedDescription, "Encoding Failed:")
        }
    }
    
    func testExportCollectionToJsonSuccess() {
        let expectation = self.expectation(description: #function)
        whiskeyLibrary.exportWhiskeyCollectionAsJSON { result in
            
            switch result {
            case .success(let fileURL):
                XCTAssertEqual("/path/to/mock/file.json", fileURL.path)
                // Additional checks can be performed here, like comparing file contents
            case .failure:
                XCTFail("Expected success but received failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}

