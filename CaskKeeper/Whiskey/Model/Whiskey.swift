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
            return .lead
        case .opened:
            return Color.regularGreen
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
    var purchasedDate: Date?
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
    var price: Double?
    var wouldBuyAgain: Bool = false
    var locationPurchased: String = ""
    var bottleFinished: Bool = false
    var tastingNotes: [Taste] = []
    
    var uniqueKey: String {
        let purchasedDateString = purchasedDate.map { Whiskey.dateFormatter.string(from: $0)} ?? "N/A"
        let priceString = price.map { String($0) } ?? "N/A"
        
        return "\(label)-\(bottle)-\(batch)-\(purchasedDateString)-\(proof)-\(style)-\(origin)-\(age)-\(priceString)"
    }
    
    var openedFor: String {
        var dateString = ""
        let calendar = Calendar.current
        
        guard let dateOpened = dateOpened else {
            dateString = "Opened Date Not Set"
            return dateString
        }
        
        if !bottleFinished {
            let dateDifference = calendar.dateComponents([.day], from: dateOpened, to: .now)
            
            if let day = dateDifference.day {
                dateString += "  \(day) \(day == 1 ? "day" : "days")"
                return dateString
            }
        } else {
            guard let consumedDate = consumedDate else { return "Sealed" }
            let dateDifference = calendar.dateComponents([.day], from: dateOpened, to: consumedDate)
            
            if let day = dateDifference.day {
                dateString += "  \(day) \(day == 1 ? "day" : "days")"
                return dateString
            }
        }
        return "Sealed"
    }
    
    var image: Image? {
        if let data = imageData, let uiImage = UIImage(data: data) {
            // Resize the image to your required size while maintaining aspect ratio
            if let resizedImage = resizeImage(image: uiImage, targetSize: CGSize(width: 115, height: 115)) {
                return Image(uiImage: resizedImage)
            }
        }
        return nil
    }
    
    var avgScore: Double {
        let totalScore = tastingNotes.reduce(0, {$0 + $1.score})
        return !tastingNotes.isEmpty ? Double(totalScore) / Double(tastingNotes.count) : 0.0
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    init(id: UUID = UUID(), label: String, bottle: String, purchasedDate: Date?, dateOpened: Date? = nil, locationPurchased: String? = nil, image: UIImage? = nil, proof: Double, bottleState: BottleState, style: Style, finish: String? = nil, origin: Origin, age: Double?, price: Double?, tastingNotes: [Taste] = []) {
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
        self.price = price ?? 0
        self.dateOpened = dateOpened
        self.locationPurchased = locationPurchased ?? ""
        self.tastingNotes = tastingNotes
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case label
        case bottle
        case batch
        case purchasedDate
        case proof
        case style
        case origin
        case age
        case finish
        case bottleState
        case opened
        case imageData
        case firstOpen
        case dateOpened
        case consumedDate
        case price
        case wouldBuyAgain
        case locationPurchased
        case bottleFinished
        case tastingNotes
    }
    
    enum ExportingCodingKeys: String, CodingKey {
        case id
        case label
        case bottle
        case batch
        case purchasedDate
        case proof
        case style
        case origin
        case age
        case finish
        case bottleState
        case opened
        case firstOpen
        case dateOpened
        case consumedDate
        case price
        case wouldBuyAgain
        case locationPurchased
        case bottleFinished
        case tastingNotes
    }
    
    func encode(to encoder: Encoder) throws {
        if encoder.userInfo[CodingUserInfoKey(rawValue: "exporting")!] as? Bool == true {
            var container = encoder.container(keyedBy: ExportingCodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(label, forKey: .label)
            try container.encode(bottle, forKey: .bottle)
            try container.encode(batch, forKey: .batch)
            try container.encode(proof, forKey: .proof)
            try container.encode(style, forKey: .style)
            try container.encode(origin, forKey: .origin)
            try container.encode(age, forKey: .age)
            try container.encode(finish, forKey: .finish)
            try container.encode(bottleState, forKey: .bottleState)
            try container.encode(opened, forKey: .opened)
            try container.encode(firstOpen, forKey: .firstOpen)
            try encodeDateIfPresent(date: self.dateOpened, to: &container, forKey: .dateOpened)
            try encodeDateIfPresent(date: self.consumedDate, to: &container, forKey: .consumedDate)
            try container.encode(price, forKey: .price)
            try container.encode(wouldBuyAgain, forKey: .wouldBuyAgain)
            try container.encode(locationPurchased, forKey: .locationPurchased)
            try container.encode(bottleFinished, forKey: .bottleFinished)
            try container.encode(tastingNotes, forKey: .tastingNotes)
            try container.encode(purchasedDate, forKey: .purchasedDate)
            try encodeDateIfPresent(date: self.purchasedDate, to: &container, forKey: .purchasedDate)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(label, forKey: .label)
            try container.encode(bottle, forKey: .bottle)
            try container.encode(batch, forKey: .batch)
            try container.encode(proof, forKey: .proof)
            try container.encode(style, forKey: .style)
            try container.encode(origin, forKey: .origin)
            try container.encodeIfPresent(imageData, forKey: .imageData)
            try container.encode(age, forKey: .age)
            try container.encode(finish, forKey: .finish)
            try container.encode(bottleState, forKey: .bottleState)
            try container.encode(opened, forKey: .opened)
            try container.encode(firstOpen, forKey: .firstOpen)
            try encodeDateIfPresent(date: self.dateOpened, to: &container, forKey: .dateOpened)
            try encodeDateIfPresent(date: self.consumedDate, to: &container, forKey: .consumedDate)
            try container.encode(price, forKey: .price)
            try container.encode(wouldBuyAgain, forKey: .wouldBuyAgain)
            try container.encode(locationPurchased, forKey: .locationPurchased)
            try container.encode(bottleFinished, forKey: .bottleFinished)
            try container.encode(tastingNotes, forKey: .tastingNotes)
            try container.encode(purchasedDate, forKey: .purchasedDate)
            try encodeDateIfPresent(date: self.purchasedDate, to: &container, forKey: .purchasedDate)
        }
        
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(label, forKey: .label)
        try container.encode(bottle, forKey: .bottle)
        try container.encode(batch, forKey: .batch)
        try container.encode(proof, forKey: .proof)
        try container.encode(style, forKey: .style)
        try container.encode(origin, forKey: .origin)
        try container.encode(age, forKey: .age)
        try container.encode(finish, forKey: .finish)
        try container.encode(bottleState, forKey: .bottleState)
        try container.encode(opened, forKey: .opened)
        try container.encode(firstOpen, forKey: .firstOpen)
        try encodeDateIfPresent(date: self.dateOpened, to: &container, forKey: .dateOpened)
        try encodeDateIfPresent(date: self.consumedDate, to: &container, forKey: .consumedDate)
        try container.encode(price, forKey: .price)
        try container.encode(wouldBuyAgain, forKey: .wouldBuyAgain)
        try container.encode(locationPurchased, forKey: .locationPurchased)
        try container.encode(bottleFinished, forKey: .bottleFinished)
        try container.encode(tastingNotes, forKey: .tastingNotes)
        try container.encode(purchasedDate, forKey: .purchasedDate)
        try encodeDateIfPresent(date: self.purchasedDate, to: &container, forKey: .purchasedDate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decodeDate(forKey key: CodingKeys) throws -> Date? {
            guard let dateString = try container.decodeIfPresent(String.self, forKey: key) else {
                return nil
            }
            if let date = Whiskey.dateFormatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
        }
        
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        id = try container.decode(UUID.self, forKey: .id)
        label = try container.decode(String.self, forKey: .label)
        bottle = try container.decode(String.self, forKey: .bottle)
        batch = try container.decode(String.self, forKey: .batch)
        purchasedDate = try decodeDate(forKey: .purchasedDate)
        proof = try container.decode(Double.self, forKey: .proof)
        style = try container.decode(Style.self, forKey: .style)
        origin = try container.decode(Origin.self, forKey: .origin)
        age = try container.decode(Double.self, forKey: .age)
        finish = try container.decode(String.self, forKey: .finish)
        bottleState = try container.decode(BottleState.self, forKey: .bottleState)
        opened = try container.decode(Bool.self, forKey: .opened)
        firstOpen = try container.decode(Bool.self, forKey: .firstOpen)
        dateOpened = try decodeDate(forKey: .dateOpened)
        consumedDate = try decodeDate(forKey: .consumedDate)
        price = try container.decode(Double.self, forKey: .price)
        wouldBuyAgain = try container.decode(Bool.self, forKey: .wouldBuyAgain)
        locationPurchased = try container.decode(String.self, forKey: .locationPurchased)
        bottleFinished = try container.decode(Bool.self, forKey: .bottleFinished)
        tastingNotes = try container.decode([Whiskey.Taste].self, forKey: .tastingNotes)
    }
    
    convenience init?(row: String) {
        var columns = row.components(separatedBy: ",")
        while columns.count > 12 && columns.last?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            columns.removeLast()
        }
        guard columns.count == 12 else { return nil }
        
        let trimmedColumns = columns.map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        
        guard !trimmedColumns[0].isEmpty, // Label
              !trimmedColumns[1].isEmpty, // Bottle
              let style = Style(rawValue: trimmedColumns[2]),
              let bottleState = BottleState(rawValue: trimmedColumns[3]),
              let origin = Origin(rawValue: trimmedColumns[4])
        else { return nil }
        
        guard let proof = Double(trimmedColumns[6]) else { return nil }
        
        let age = Double(trimmedColumns[7])
        let finish = trimmedColumns[5].isEmpty ? "" : trimmedColumns[5]
        let purchasedDate = Whiskey.dateFormatter.date(from: trimmedColumns[8]) // This can be nil
        let dateOpened = Whiskey.dateFormatter.date(from: trimmedColumns[9]) // This can be nil as well
        let locationPurchased = trimmedColumns[10].isEmpty ? "" : trimmedColumns[10]
        let priceString = trimmedColumns[11]
        let price = priceString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : Double(priceString)

        self.init(label: trimmedColumns[0], bottle: trimmedColumns[1], purchasedDate: purchasedDate, dateOpened: dateOpened, locationPurchased: locationPurchased, proof: proof, bottleState: bottleState, style: style, finish: finish, origin: origin, age: age, price: price, tastingNotes: [])
    }
    
    struct Taste: Hashable, Codable, Equatable {
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
        
        enum CodingKeys: CodingKey {
            case customNotes
            case date
            case notes
            case score
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(customNotes, forKey: .customNotes)
            let dateString = Whiskey.dateFormatter.string(from: self.date)
            try container.encode(dateString, forKey: .date)
            try container.encode(notes, forKey: .notes)
            try container.encode(score, forKey: .score)
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let customNotes = try container.decodeIfPresent(String.self, forKey: .customNotes)
            
            let dateString = try container.decode(String.self, forKey: .date)
            
            if let date = Whiskey.dateFormatter.date(from: dateString) {
                self.date = date
            } else {
                throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
            
            let notes = try container.decode([Flavor].self, forKey: .notes)
            let score = try container.decode(Int.self, forKey: .score)
            
            self.id = UUID()
            self.customNotes = customNotes
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
    
    func encodeDateIfPresent<T: CodingKey>(date: Date?, to container: inout KeyedEncodingContainer<T>, forKey key: T) throws {
        if let date = date {
            let dateString = Whiskey.dateFormatter.string(from: date)
            try container.encode(dateString, forKey: key)
        } else {
            try container.encodeNil(forKey: key) // Explicitly encode nil if there is no date
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        let scaleFactor = min(widthRatio, heightRatio)

        let scaledImageSize = CGSize(
            width: image.size.width * scaleFactor,
            height: image.size.height * scaleFactor
        )

        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }

        return scaledImage
    }


}
