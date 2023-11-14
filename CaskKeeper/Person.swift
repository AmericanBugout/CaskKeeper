//
//  Person.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/13/23.
//

import Foundation
import Observation

@Observable
class Person: Hashable, Codable, Identifiable, Equatable  {
    
    var id: UUID
    var first: String
    var last: String
    var age: Int
    
    init(id: UUID = UUID(), first: String, last: String, age: Int) {
        self.id = id
        self.first = first
        self.last = last
        self.age = age
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    convenience init?(csvRow: String) {

        let columns = csvRow.components(separatedBy: ",")
        guard columns.count == 3 else { return nil }
        
        let trimmedColumns = columns.map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
                
        let first = trimmedColumns[0].nonEmpty
        let last = trimmedColumns[1].nonEmpty
//        guard let first = trimmedColumns[0], let last = trimmedColumns[1] else {
//            return nil
//        }
//        
        guard let ageToInt = Int(trimmedColumns[2]) else {
            return nil
        }
        
        self.init(id: UUID(), first: first ?? "", last: last ?? "", age: ageToInt)

    }
    
}

@Observable class People {
    var people: [Person] = []
}
