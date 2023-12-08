//
//  MockEncoder.swift
//  CaskKeeperTests
//
//  Created by Jon Oryhan on 12/7/23.
//

import Foundation
@testable import CaskKeeper

class MockFailingEncoder: WhiskeyEncoding {
    func encode(_ collection: [Whiskey]) throws -> Data {
        throw DataManagerError.encodingFailed
    }
}
