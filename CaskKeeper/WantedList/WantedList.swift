//
//  Whiskey.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI
import Observation

@Observable
class WantedList: Identifiable, Hashable, Codable {
    static func == (lhs: WantedList, rhs: WantedList) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID
    var name: String
    var style: String
    var description: String?
    var dateCreated: Date
    var whiskeys: [WhiskeyItem] = []

    // Computed properties
    var wantedCount: Int {
        whiskeys.filter({$0.state == .looking}).count
    }
    
    var foundCount: Int {
        whiskeys.filter({$0.state == .found}).count
    }
    
    // Initializer
    init(id: UUID = UUID(), name: String, style: String, description: String?, whiskeys: [WhiskeyItem] = [], dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.style = style
        self.description = description
        self.dateCreated = dateCreated
        self.whiskeys = whiskeys
    }
    
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, name, style, description, dateCreated, whiskeys
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(style, forKey: .style)
        try container.encode(description, forKey: .description)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(whiskeys, forKey: .whiskeys)
    }
    
    // Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        style = try container.decode(String.self, forKey: .style)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        whiskeys = try container.decode([WhiskeyItem].self, forKey: .whiskeys)
        id = try container.decode(UUID.self, forKey: .id)
    }
}
