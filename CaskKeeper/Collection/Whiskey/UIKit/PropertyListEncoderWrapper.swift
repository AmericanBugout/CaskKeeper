//
//  PropertyListEncoderWrapper.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/7/23.
//

import Foundation

protocol WhiskeyEncoding {
    func encode(_ collection: [Whiskey]) throws -> Data
}

class PropertyListEncoderWrapper: WhiskeyEncoding {
    private let encoder = PropertyListEncoder()

    func encode(_ collection: [Whiskey]) throws -> Data {
        return try encoder.encode(collection)
    }
}
