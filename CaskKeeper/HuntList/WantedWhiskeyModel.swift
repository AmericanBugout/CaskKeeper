//
//  TargetWhiskeyModel.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import Observation
import SwiftUI

@Observable
class WantedWhiskeyModel {
    var whiskeys: [WantedWhiskey] = []
    var whiskeyToAdd = WhiskeyToAdd()
    
    init(isForTesting: Bool = false) {
        if isForTesting {
            whiskeys = [
                WantedWhiskey(label: "E.H. Taylor Rye", bottle: "Straight Rye", notes: ""),
                WantedWhiskey(label: "Russel's Reserve", bottle: "Single Rickhouse LE", notes: "")
            ]
        }
    }
}
