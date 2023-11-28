//
//  WhiskeyItem.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/27/23.
//

import SwiftUI
import Observation

enum SearchState: Codable {
    case looking
    case found
}

@Observable
class WhiskeyItem: Codable, Hashable, Identifiable {
    var id: UUID
    
    /* label of the bottle */
    var name: String = ""
    
    /* searching state */
    var state: SearchState = .looking
    
    /* start search date */
    var startSearchDate: Date?
    
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