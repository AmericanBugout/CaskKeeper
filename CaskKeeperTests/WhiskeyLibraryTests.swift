//
//  WhiskeyLibraryTests.swift
//  CaskKeeperTests
//
//  Created by Jon Oryhan on 12/5/23.
//

import XCTest

@testable import CaskKeeper

final class WhiskeyLibraryTests: XCTestCase {
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
    
    func testInitializationWithTestingData() {
        let mockPersistence = MockWhiskeyDataPersistenceManager()
        let whiskeyLibrary = WhiskeyLibrary(dataPersistence: mockPersistence, isForTesting: true)

        let collection = whiskeyLibrary.collection
        XCTAssertTrue(collection.contains(where: { $0.label == "Hammered" }), "Collection should contain 'Hammered' whiskey.")
        XCTAssertTrue(collection.contains(where: { $0.label == "Big Tower Whiskey" }), "Collection should contain 'Big Tower Whiskey'.")
        XCTAssertTrue(collection.contains(where: { $0.label == "Rattle Creek" }), "Collection should contain 'Rattle Creek'.")
        XCTAssertTrue(collection.contains(where: { $0.label == "Small Reserve" }), "Collection should contain 'Small Reserve'.")
        XCTAssertEqual(collection.count, 4)
    }
    
    func testInitializationWithLoadedData() {

        let collection = whiskeyLibrary.collection
        XCTAssertTrue(dataPersistenceManager.loadIsCalled, "load() method should be called on the dataPersistenceManager.")
        XCTAssertEqual(collection.count, 2, "Collection should have 2 whiskeys loaded from dataPersistenceManager.")
        XCTAssertTrue(collection.contains(where: { $0.id == dataPersistenceManager.whiskey1ID }), "Collection should contain whiskey with whiskey1ID.")
        XCTAssertTrue(collection.contains(where: { $0.id == dataPersistenceManager.whiskey2ID }), "Collection should contain whiskey with whiskey2ID.")
    }

    func testWhiskeysAreNotNil() {
        XCTAssertNotNil(whiskeyLibrary?.collection)
    }
    
    func testWhiskeyCount() {
        XCTAssertEqual(whiskeyLibrary?.collectionCount, 2, "Collection does not equal 2.")
    }
    
    func testAddWhiskey() {
        whiskeyLibrary?.addWhiskey(whiskey: Whiskey(label: "testLabel", bottle: "testBottle", purchasedDate: Date(), proof: 100, bottleState: .opened, style: .bourbon, origin: .us, age: 8, price: 99.99))
        XCTAssertEqual(whiskeyLibrary?.collectionCount, 3, "Whiskey was not appended.")
    }
    
    func testSwipeToDeleteOffsets() {
        let whiskey = IndexSet(integer: 0)
        whiskeyLibrary?.deleteAtIndex(index: whiskey)
        XCTAssertEqual(whiskeyLibrary?.collectionCount, 1, "Did not delete first index of array.")
    }
    
    func testUpdateWhiskey() {
        let whiskey = whiskeyLibrary?.collection.first!
        whiskey?.label = "test"
        whiskeyLibrary?.updateWhiskey(updatedWhiskey: whiskey!)
        XCTAssertEqual(whiskeyLibrary?.collection.first!.label, "test", "Update did not work.")
    }
    
    func testUpdateImageData() {
        guard let whiskey = whiskeyLibrary?.collection.first! else { return }
        let image = UIImage(named: "whiskey1")
        guard let data = image?.pngData() else { return }
        whiskeyLibrary?.updateImage(for: whiskey, with: data)
        XCTAssertEqual(whiskey.imageData, data, "Data does not match")
    }
    
    func testAddWhiskeyTasting() {
        let tasting = Whiskey.Taste(date: Date(), customNotes: "Test Note")
        whiskeyLibrary.addWhiskeyTasting(for: whiskeyLibrary.collection.first!, tasting: tasting)
        XCTAssertEqual(whiskeyLibrary.collection.first!.tastingNotes.count, 3, "Note was not added.")
    }
    
    func testDeleteWhiskeyTasting() {
        let whiskey = whiskeyLibrary.collection.first!
        let tastingCountOriginal = whiskey.tastingNotes.count
        let indexSet = IndexSet(integer: whiskey.tastingNotes.indices.last!)
        whiskeyLibrary.deleteTasting(whiskey: whiskey, indexSet: indexSet)
        XCTAssertEqual(whiskey.tastingNotes.count, tastingCountOriginal - 1, "Tasting note count should decrease by one")
        XCTAssertEqual(whiskey.tastingNotes.last!.customNotes, "Intense Flavor. I would definately buy again.", "The wrong note was removed.")
    }
    
    func testUpdateWhiskeyToFinished() {
        let whiskey = whiskeyLibrary.collection.first!
        whiskeyLibrary.updateWhiskeyToFinished(whiskey: whiskey)
        XCTAssertTrue(whiskey.bottleFinished)
        XCTAssertFalse(whiskey.opened)
        XCTAssertEqual(whiskey.bottleState, .finished, "Whiskey state is not finished")
    }
    
    func testWhiskeyWasOpened() {
        let whiskey = whiskeyLibrary.collection.first!
        XCTAssertNil(whiskey.dateOpened)
        whiskeyLibrary.updateOpenedDate(whiskey: whiskey)
        XCTAssertEqual(whiskey.bottleState, .opened, "Whiskey state is not opened.")
        XCTAssertEqual(whiskey.firstOpen, false, "First Open should be false.")
        XCTAssertNotNil(whiskey.dateOpened)
        
    }
    
    func testExportWhiskeyAsJSONisSuccessful() {
        let expectation = self.expectation(description: #function)
        whiskeyLibrary.exportWhiskeyCollectionAsJSON { result in
            if case .success(let url) = result {
                XCTAssertNotNil(url, "URL should not be nil when export is successful.")
            } else {
                XCTFail("Export should succeed.")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testExportWhiskeyAsJSONisFailure() {
        let expectation = self.expectation(description: #function)
        dataPersistenceManager.shouldExportSuccessfully = false
        
        whiskeyLibrary.exportWhiskeyCollectionAsJSON { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error, "Error should not be nil on failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    
    func testImportWhiskeysAsJSON() {
        let expectation = self.expectation(description: #function)
        let mockURL = URL(fileURLWithPath: "path/to/mock/file.json")
        whiskeyLibrary.importWhiskeyCollectionFromJSON(fileURL: mockURL) { result in
            if case .success(let whiskeys) = result {
                XCTAssertEqual(whiskeys.count, 2, "Import failed")
            } else {
                XCTFail("Import should succeed.")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testProcessImportedWhiskeys() {
        let whiskey1ID = UUID(uuidString: "1ea050f2-1ab1-5e22-bc76-cb86520f4678")!
        let initialCount = 2

        let whiskeys = [
            Whiskey(id: whiskey1ID, label: "testLabel", bottle: "testBottle", purchasedDate: nil, dateOpened: nil, locationPurchased: nil, image: nil, proof: 100, bottleState: .opened, style: .bourbon, finish: nil, origin: .us, age: nil, price: nil, tastingNotes: []),
            Whiskey(id: UUID(), label: "testLabel2", bottle: "testBottle2", purchasedDate: nil, dateOpened: nil, locationPurchased: nil, image: nil, proof: 110, bottleState: .opened, style: .bourbon, finish: nil, origin: .us, age: nil, price: nil, tastingNotes: [])
        ]
        
        let expectation = self.expectation(description: #function)
        whiskeyLibrary.processImportedWhiskeys(importedWhiskeys: whiskeys)
        
        DispatchQueue.main.async {
            let finalCount = self.whiskeyLibrary.collection.count
            XCTAssertEqual(finalCount, initialCount + 1, "Total count should increase by 1 after importing non-duplicate whiskey.")
            
            XCTAssertEqual(self.whiskeyLibrary.importedWhiskeyCount, 1, "Should have imported one new whiskey.")
            XCTAssertEqual(self.whiskeyLibrary.duplicateWhiskeyCountOnJSONImport, 1, "Should have found one duplicate whiskey.")

            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSetCountsToNil() {
        whiskeyLibrary.importedWhiskeyCount = 5
        whiskeyLibrary.duplicateWhiskeyCountOnJSONImport = 3
        whiskeyLibrary.setCountsToNil()
        
        XCTAssertNil(whiskeyLibrary.importedWhiskeyCount)
        XCTAssertNil(whiskeyLibrary.duplicateWhiskeyCountOnJSONImport)
    }
    
    /* Data persitence tests */
    func testDataPersistenceFailedTest() {
        dataPersistenceManager.setupLoadForFailure()
        let loadedWhiskeys = dataPersistenceManager.load()
        
        XCTAssertTrue(loadedWhiskeys.isEmpty, "Loaded whiskeys should be empty error occurred.")
    }
    
    func testDataPersistenceSave() {
        
    }
    
}


