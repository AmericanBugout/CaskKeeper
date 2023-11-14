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
    
    init(id: UUID = UUID(), label: String, bottle: String, style: Style, origin: Origin, finish: String?, proof: Double, bottleState: BottleState) {
        self.id = id
        self.label = label
        self.bottle = bottle
        self.style = style
        self.origin = origin
        self.finish = finish ?? ""
        self.proof = proof
        self.bottleState = bottleState
    }
    
    convenience init?(row: String) {

        let columns = row.components(separatedBy: ",")
        guard columns.count == 7 else { return nil }
        
        let trimmedColumns = columns.map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
                
        guard !trimmedColumns[0].isEmpty,
              !trimmedColumns[1].isEmpty,
              let style = Style(rawValue: trimmedColumns[2]),
              let bottleState = BottleState(rawValue: trimmedColumns[3]),
              let origin = Origin(rawValue: trimmedColumns[4]),
              let proof = Double(trimmedColumns[6])
        else { return nil }
        
        let finish = trimmedColumns[5].isEmpty ? "" : trimmedColumns[5]
        
        self.init(label: trimmedColumns[0], bottle: trimmedColumns[1], style: style, origin: origin, finish: finish, proof: proof, bottleState: bottleState)

    }
    
}

@Observable class TrialWhiskey {
    var trial: [SmallWhiskey] = []
}
