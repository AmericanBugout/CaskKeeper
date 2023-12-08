//
//  MockWhiskeyData.swift
//  CaskKeeperTests
//
//  Created by Jon Oryhan on 12/7/23.
//

import Foundation
@testable import CaskKeeper

struct MockWhiskeyData {
    
    static let whiskeys = [
        Whiskey(id: UUID(), label: "loadedWhiskey1", bottle: "testBottle2", purchasedDate: nil, proof: 100, bottleState: .sealed, style: .bourbon, origin: .us, age: 8, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Intense Flavor. I would definately buy again.", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Burnt Toast")], score: 56), Whiskey.Taste(date: Date(), customNotes: "Cost a lot of money.  Will Need another taste to determine its worth", notes: [Flavor(name: "Oak"), Flavor(name: "Wood"), Flavor(name: "Burnt Toast")], score: 78)]),
        Whiskey(id: UUID(), label: "loadedWhiskey2", bottle: "testBottle2", purchasedDate: nil, proof: 110, bottleState: .opened, style: .rye, origin: .us, age: 10, price: nil, tastingNotes: [Whiskey.Taste(date: Date(), customNotes: "Strong Oak. Fruity. Not sure I would buy again at the price point", notes: [Flavor(name: "Oak"), Flavor(name: "Cherry"), Flavor(name: "Fruity")], score: 78)])
    ]
}
