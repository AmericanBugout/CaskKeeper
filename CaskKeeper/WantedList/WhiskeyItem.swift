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
    
    /* label of the bottle */
    var name: String = ""
    
    /* searching state */
    var state: SearchState = .looking
    
    /* end search date */
    var endSearchDate: Date?
        
    init(id: UUID = UUID(), name: String = "") {
        self.id = id
        self.name = name
    }
}

extension WhiskeyItem {
    
    /* Conform to Hashable */
    static func == (lhs: WhiskeyItem, rhs: WhiskeyItem) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
