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
    var age: Double
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
    
    init(id: UUID = UUID(), label: String, bottle: String, purchasedDate: Date, dateOpened: Date? = nil,locationPurchased: String? = nil, image: UIImage? = nil, proof: Double, bottleState: BottleState, style: Style, finish: String? = nil, origin: Origin, age: Double?, tastingNotes: [Taste] = []) {
        self.id = id
        self.label = label
        self.bottle = bottle
        self.purchasedDate = purchasedDate
        self.imageData = image?.jpegData(compressionQuality: 0.3)
        self.proof = proof
        self.bottleState = bottleState
        self.style = style
        self.finish = finish ?? ""
        self.origin = origin
        self.age = age ?? 0
        self.dateOpened = dateOpened
        self.locationPurchased = locationPurchased ?? ""
        self.tastingNotes = tastingNotes
    }

    convenience init?(row: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy" // Adjust to match "6/15/2023" with no leading zeros
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use POS

        let columns = row.components(separatedBy: ",")
        guard columns.count == 11 else { return nil }
        
        let trimmedColumns = columns.map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
                
        guard !trimmedColumns[0].isEmpty, // Label
              !trimmedColumns[1].isEmpty, // Bottle
              !trimmedColumns[10].isEmpty, // Location Purchased
              let style = Style(rawValue: trimmedColumns[2]),
              let bottleState = BottleState(rawValue: trimmedColumns[3]),
              let origin = Origin(rawValue: trimmedColumns[4])
        else { return nil }
        
        guard let proof = Double(trimmedColumns[6]) else { return nil }
        let age = Double(trimmedColumns[7])
        
        let finish = trimmedColumns[5].isEmpty ? "" : trimmedColumns[5]
        
        guard let purchasedDate = dateFormatter.date(from: trimmedColumns[8]) else { return nil }
        let dateOpened = dateFormatter.date(from: trimmedColumns[9])

        
        self.init(label: trimmedColumns[0], bottle: trimmedColumns[1], purchasedDate: purchasedDate, dateOpened: dateOpened, locationPurchased: trimmedColumns[10], proof: proof, bottleState: bottleState, style: style, finish: finish, origin: origin, age: age, tastingNotes: [])
        
    }
    
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
