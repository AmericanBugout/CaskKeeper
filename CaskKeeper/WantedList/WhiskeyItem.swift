//
//  WhiskeyItem.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/27/23.
//

import SwiftUI
import Observation

enum SearchState: String, Codable {
    case looking = "Looking"
    case found = "Found"
    
    var currentState: String {
        switch self {
        case .looking:
            return "Looking"
        case .found:
            return "Found"
        }
    }
}

@Observable
class WhiskeyItem: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var state: SearchState
    var endSearchDate: Date?
    
    init(id: UUID = UUID(), name: String, state: SearchState = .looking) {
        self.id = id
        self.name = name
        self.state = state
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        state = try container.decode(SearchState.self, forKey: .state)
        endSearchDate = try container.decodeIfPresent(Date.self, forKey: .endSearchDate) ?? nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(state, forKey: .state)
        try container.encodeIfPresent(endSearchDate, forKey: .endSearchDate)
    }
    
    
    // Ensure CodingKeys match your property names
    enum CodingKeys: String, CodingKey {
        case id, name, state, endSearchDate
    }
    
    static func == (lhs: WhiskeyItem, rhs: WhiskeyItem) -> Bool {
        lhs.id == rhs.id // Comparing by ID might be more appropriate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
