//
//  SmallWhiskey.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/13/23.
//

import SwiftUI
import Observation

@Observable
class SmallWhiskey: Hashable, Codable, Identifiable, Equatable  {
    
    static func == (lhs: SmallWhiskey, rhs: SmallWhiskey) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id: UUID
    var label: String
    var bottle: String
    var style: Style
    var origin: Origin
    var finish: String = ""
    var proof: Double
    var bottleState: BottleState
    var age: Double
    var purchasedDate: Date
    
    init(id: UUID = UUID(), label: String, bottle: String, style: Style, origin: Origin, age: Double?, finish: String?, proof: Double, bottleState: BottleState, purchaseDate: Date) {
        self.id = id
        self.label = label
        self.bottle = bottle
        self.style = style
        self.origin = origin
        self.age = age ?? 0
        self.finish = finish ?? ""
        self.proof = proof
        self.bottleState = bottleState
        self.purchasedDate = purchaseDate
    }
    
    convenience init?(row: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy" // Adjust to match "6/15/2023" with no leading zeros
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use POS

        let columns = row.components(separatedBy: ",")
        guard columns.count == 9 else { return nil }
        
        let trimmedColumns = columns.map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
                
        guard !trimmedColumns[0].isEmpty,
              !trimmedColumns[1].isEmpty,
              let style = Style(rawValue: trimmedColumns[2]),
              let bottleState = BottleState(rawValue: trimmedColumns[3]),
              let origin = Origin(rawValue: trimmedColumns[4])
        else { return nil }
        
        guard let proof = Double(trimmedColumns[6]) else { return nil }
        let age = Double(trimmedColumns[7])
        
        let finish = trimmedColumns[5].isEmpty ? "" : trimmedColumns[5]
        
        guard let purchasedDate = dateFormatter.date(from: trimmedColumns[8]) else { return nil }
        
        
        self.init(label: trimmedColumns[0], bottle: trimmedColumns[1], style: style, origin: origin, age: age, finish: finish, proof: proof, bottleState: bottleState, purchaseDate: purchasedDate)
    }
    
}

