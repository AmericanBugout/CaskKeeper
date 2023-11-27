//
//  Whiskey.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI
import Observation


struct WantedWhiskey: Identifiable {
    var id: UUID
    var label: String
    var bottle: String
    var notes: String
    
    init(id: UUID = UUID(), label: String, bottle: String, notes: String) {
        self.id = id
        self.label = label
        self.bottle = bottle
        self.notes = notes
    }
}
