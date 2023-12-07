//
//  WhiskeyDataPersistenceTests.swift
//  CaskKeeperTests
//
//  Created by Jon Oryhan on 12/6/23.
//

import XCTest
@testable import CaskKeeper

final class WhiskeyDataPersistenceTests: XCTestCase {
    var dataPersistenceManager: MockWhiskeyDataPersistenceManager!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        dataPersistenceManager = MockWhiskeyDataPersistenceManager()
    }

    override func tearDownWithError() throws {
        dataPersistenceManager = nil
    }
    
    func testExportFailed() {
        dataPersistenceManager.shouldExportSuccessfully = false
        
    }
    
}
