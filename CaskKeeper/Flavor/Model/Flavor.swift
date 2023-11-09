//
//  Flavor.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/4/23.
//

import Foundation
import Observation

@Observable
class Flavor: Identifiable, Hashable, Comparable, Codable {
    
    let id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
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
