//
//  Whiskey.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI
import Observation

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
    var opened: Bool = false
    var firstOpen: Bool = true
    var dateOpened: Date?
    var consumedDate: Date?
    var wouldBuyAgain: Bool = false
    var isOpenedFor6Months: Bool = false
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
        if bottleFinished {
            guard let dateOpened = dateOpened, let consumedDate = consumedDate else {
                return "N/A"
            }
            let calendar = Calendar.current
            let dateDifference = calendar.dateComponents([.day], from: dateOpened, to: consumedDate)
            if let day = dateDifference.day {
                return "\(day) \(day == 1 ? "day" : "days")"
            } else {
                return "0 days"
            }
            
        } else {
            guard let dateOpened = dateOpened else {
                return "N/A"
            }
            let today = Date()
            let calendar = Calendar.current
            let dateDifference = calendar.dateComponents([.day], from: dateOpened, to: today)
            
            if let day = dateDifference.day {
              let dayString = "\(day) \(day == 1 ? "day" : "days")"
              return dayString
            } else {
                return "0 days"
            }
        }
        
    }
    
    init(id: UUID = UUID(), label: String, bottle: String, purchasedDate: Date, image: UIImage? = nil, proof: Double, style: Style, origin: Origin, age: Age, tastingNotes: [Taste] = []) {
        self.id = id
        self.label = label
        self.bottle = bottle
        self.purchasedDate = purchasedDate
        self.imageData = image?.jpegData(compressionQuality: 0.3)
        self.proof = proof
        self.style = style
        self.origin = origin
        self.age = age
        self.tastingNotes = tastingNotes
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

