//
//  Flavor.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/4/23.
//

import SwiftUI
import Observation

@Observable
class Flavor: Identifiable, Hashable, Comparable, Codable {
    
    var id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
      //  try container.encode(id.self, forKey: .id)
        try container.encode(name.self, forKey: .name)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
        
    static func == (lhs: Flavor, rhs: Flavor) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    static func < (lhs: Flavor, rhs: Flavor) -> Bool {
        return lhs.name < rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
