//
//  Whiskey.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI
import Observation

enum BottleState: String, Codable {
    case sealed = "Sealed"
    case opened = "Open"
    case finished = "Finished"
    
    var currentState: String {
        switch self {
        case .sealed:
            return "Sealed"
        case .opened:
            return "Open"
        case .finished:
            return "Finished"
        }
    }
    
    var color: Color {
      switch self {
      case .sealed:
          return .gray
      case .opened:
          return .green
      case .finished:
          return .accentColor
      }
  }
}

@Observable
class Whiskey: Hashable, Codable, Identifiable, Equatable {
    var id: UUID
    var label: String
    var bottle: String
    var batch: String = ""
    var purchasedDate: Date
    var imageData: Data?
    var proof: Double
    var style: Style
    var origin: Origin
    var age: Age
    var finish: String = ""
    var bottleState: BottleState = .sealed
    var opened: Bool = false
    var firstOpen: Bool = true
    var dateOpened: Date?
    var consumedDate: Date?
    var wouldBuyAgain: Bool = false
    var locationPurchased: String = ""
    var bottleFinished: Bool = false
    var tastingNotes: [Taste] = []
    
    var image: Image? {
        if let data = imageData {
            if let newImage = UIImage(data: data) {
                return Image(uiImage: newImage)
            }
        }
        return nil
    }
    
    var avgScore: Double {
        let totalScore = tastingNotes.reduce(0, {$0 + $1.score})
        return !tastingNotes.isEmpty ? Double(totalScore) / Double(tastingNotes.count) : 0.0
    }
    
    var openedFor: String {
        var dateString = ""
        let calendar = Calendar.current
              
        guard let dateOpened = dateOpened else {
           dateString = "Sealed"
           return dateString
        }
        
        if !bottleFinished {
            let dateDifference = calendar.dateComponents([.day, .hour, .minute], from: dateOpened, to: .now)
            
            if let day = dateDifference.day {
                dateString += "  \(day) \(day == 1 ? "day" : "days")"
            }
            
            if let hour = dateDifference.hour {
                dateString += ",  \(hour) \(hour == 1 ? "hour" : "hours")"
            }
            
            if let minute = dateDifference.minute {
                dateString += ",  \(minute) \(minute == 1 ? "minute" : "minutes")"
                return dateString
            }
        } else {
            guard let consumedDate = consumedDate else { return "Sealed" }
            let dateDifference = calendar.dateComponents([.day, .hour, .minute], from: dateOpened, to: consumedDate)
            
            if let day = dateDifference.day {
                dateString += "  \(day) \(day == 1 ? "day" : "days")"
            }
            
            if let hour = dateDifference.hour {
                dateString += ",  \(hour) \(hour == 1 ? "hour" : "hours")"
            }
            
            if let minute = dateDifference.minute {
                dateString += ",  \(minute) \(minute == 1 ? "minute" : "minutes")"
                return dateString
            }
        }
        return "Sealed"
    }
    
    init(id: UUID = UUID(), label: String, bottle: String, purchasedDate: Date, image: UIImage? = nil, proof: Double, style: Style, finish: String? = nil, origin: Origin, age: Age, tastingNotes: [Taste] = []) {
        self.id = id
        self.label = label
        self.bottle = bottle
        self.purchasedDate = purchasedDate
        self.imageData = image?.jpegData(compressionQuality: 0.3)
        self.proof = proof
        self.style = style
        self.finish = finish ?? ""
        self.origin = origin
        self.age = age
        self.tastingNotes = tastingNotes
    }
    
    
//    convenience init?(csvRow: String) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "M/d/yyyy"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        
//        let columns = csvRow.components(separatedBy: ",")
//        guard columns.count >= 8 else { return nil }
//        
//        let trimmedColumns = columns.map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
//        
//        let id = UUID()
//        
//        guard let label = trimmedColumns[1].nonEmpty,
//              let bottle = trimmedColumns[2].nonEmpty,
//              let style = Style(rawValue: trimmedColumns[6]),
//              let proof = Double(trimmedColumns[5]),
//              let origin = Origin(rawValue: trimmedColumns[7]),
//              let age = Age(rawValue: trimmedColumns[8]),
//              let purchasedDate = dateFormatter.date(from: trimmedColumns[3]) else {
//            return nil
//        }
//        
//        self.init(id: id, label: label, bottle: bottle, purchasedDate: purchasedDate, proof: proof, style: style, origin: origin, age: age, tastingNotes: [])
//
//    }
//    
    struct Taste: Hashable, Codable, Identifiable, Equatable {
        var id: UUID
        var customNotes: String?
        var date: Date
        var notes: [Flavor] = []
        var score: Int = 0
        
        init(id: UUID = UUID(), date: Date, customNotes: String?, notes: [Flavor] = [], score: Int = 0) {
            self.id = id
            self.customNotes = customNotes
            self.date = date
            self.notes = notes
            self.score = score
        }
    }

    static func == (lhs: Whiskey, rhs: Whiskey) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
    func updateImage(_ image: UIImage) {
        self.imageData = image.jpegData(compressionQuality: 0.3)
    }
    
}


extension String {
    var nonEmpty: String? {
        return self.isEmpty ? nil : self
    }
}
