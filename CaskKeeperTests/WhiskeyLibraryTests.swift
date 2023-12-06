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
    var dataPersistenceManager: MockWhiskeyDataPersistanceManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        dataPersistenceManager = MockWhiskeyDataPersistanceManager()
        whiskeyLibrary = WhiskeyLibrary(dataPersistence: dataPersistenceManager, isForTesting: false)
    }

    override func tearDownWithError() throws {
        whiskeyLibrary = nil
        dataPersistenceManager = nil
        try super.tearDownWithError()
    }
    
    func testWhiskeyLibraryInitializationForProduction() {
        XCTAssertTrue(dataPersistenceManager.loadIsCalled)
    }
    
    func testWhiskeyLibraryUsedForTesting() {
        let dataPersistenceManager = MockWhiskeyDataPersistanceManager()
        whiskeyLibrary = WhiskeyLibrary(dataPersistence: dataPersistenceManager, isForTesting: true)
        XCTAssertFalse(dataPersistenceManager.loadIsCalled)
        XCTAssertNotNil(whiskeyLibrary.collection)
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
        let firstWhiskey = IndexSet(integer: 0)
        whiskeyLibrary?.deleteAtIndex(index: firstWhiskey)
        XCTAssertEqual(whiskeyLibrary?.collectionCount, 1, "Did not delete first index of array.")
    }
    
    func testUpdateWhiskey() {
        let firstWhiskey = whiskeyLibrary?.collection.first!
        firstWhiskey?.label = "test"
        whiskeyLibrary?.updateWhiskey(updatedWhiskey: firstWhiskey!)
        XCTAssertEqual(whiskeyLibrary?.collection.first!.label, "test", "Update did not work.")
    }
    
    func testUpdateImageData() {
        guard let firstWhiskey = whiskeyLibrary?.collection.first! else { return }
        let image = UIImage(named: "whiskey1")
        guard let data = image?.pngData() else { return }
        whiskeyLibrary?.updateImage(for: firstWhiskey, with: data)
        XCTAssertEqual(firstWhiskey.imageData, data, "Data does not match")
    }
    
    func testAddWhiskeyTasting() {
        let tasting = Whiskey.Taste(date: Date(), customNotes: "Test Note")
        whiskeyLibrary.addWhiskeyTasting(for: whiskeyLibrary.collection.first!, tasting: tasting)
        XCTAssertEqual(whiskeyLibrary.collection.first!.tastingNotes.count, 3, "Note was not added.")
    }
    
    func testDeleteWhiskeyTasting() {
        let firstWhiskey = whiskeyLibrary.collection.first!
        let tastingCountOriginal = firstWhiskey.tastingNotes.count
        let indexSet = IndexSet(integer: firstWhiskey.tastingNotes.indices.last!)
        whiskeyLibrary.deleteTasting(whiskey: firstWhiskey, indexSet: indexSet)
        XCTAssertEqual(firstWhiskey.tastingNotes.count, tastingCountOriginal - 1, "Tasting note count should decrease by one")
        XCTAssertEqual(firstWhiskey.tastingNotes.last!.customNotes, "Intense Flavor. I would definately buy again.", "The wrong note was removed.")
    }
    
    

}
