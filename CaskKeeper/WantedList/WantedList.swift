//
//  Whiskey.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI
import Observation

struct WantedList: Identifiable, Hashable, Codable {
    static func == (lhs: WantedList, rhs: WantedList) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    
    /* name of the list*/
    var name: String
    
    /* rye, bourbon, irish */
    var style: String
    
    /* notes about the list */
    var description: String?
    
    /* date list was created */
    var dateCreated: Date = Date()
    
    /* whiskeys */
    var whiskeys: [WhiskeyItem]?
    
    /* found whiskeys */
    var foundWhiskeys: [WhiskeyItem]?
    
    init(id: UUID = UUID(), name: String, style: String, description: String?, whiskeys: [WhiskeyItem]?) {
        self.id = id
        self.name = name
        self.style = style
        self.description = description
        self.whiskeys = whiskeys ?? []
    }
}
