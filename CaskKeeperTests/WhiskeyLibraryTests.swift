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
}
