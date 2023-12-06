//
//  WhiskeyLibraryTests.swift
//  CaskKeeperTests
//
//  Created by Jon Oryhan on 12/5/23.
//

import XCTest

@testable import CaskKeeper

final class WhiskeyLibraryTests: XCTestCase {
    var whiskeyLibrary: WhiskeyLibrary?
    var dataPersistenceManager: WhiskeyPersisting!

    override func setUpWithError() throws {
        dataPersistenceManager = WhiskeyDataPersistanceManager.shared
        whiskeyLibrary = WhiskeyLibrary(dataPersistence: dataPersistenceManager, isForTesting: true)
    }

    override func tearDownWithError() throws {
        whiskeyLibrary = nil
    }

    func testWhiskeysAreNotNil() {
        XCTAssertNotNil(whiskeyLibrary?.collection)
    }
    
    func testWhiskeyCount() {
        XCTAssertEqual(whiskeyLibrary?.collectionCount, 4, "Collection does not equal 4.")
    }
    
    func testAddWhiskey() {
        whiskeyLibrary?.addWhiskey(whiskey: Whiskey(label: "testLabel", bottle: "testBottle", purchasedDate: Date(), proof: 100, bottleState: .opened, style: .bourbon, origin: .us, age: 8, price: 99.99))
        XCTAssertEqual(whiskeyLibrary?.collectionCount, 5, "Whiskey was not appended.")
    }
    
    func testSwipeToDeleteOffsets() {
        let firstWhiskey = IndexSet(integer: 0)
        whiskeyLibrary?.deleteAtIndex(index: firstWhiskey)
        XCTAssertEqual(whiskeyLibrary?.collectionCount, 3, "Did not delete first index of array.")
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
}