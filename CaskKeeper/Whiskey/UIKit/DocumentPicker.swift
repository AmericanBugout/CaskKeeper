//
//  DocumentPicker.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/13/23.
//

import SwiftUI
import UniformTypeIdentifiers

enum DocumentPickerError: Error, LocalizedError {
    case couldNotHandleUrl
    case failedToParseContents
    case invalidHeader
    case invalidData(description: String)
    case invalidStyle(description: String)
    case invalidBottleState(description: String)
    case invalidOrigin(description: String)
    case invalidProofNumber(description: String)
    case invalidAgeNumber(description: String)
    case invalidDate(description: String)
    case invalidPrice(description: String)
    
    var errorDescription: String? {
        switch self {
        case .couldNotHandleUrl:
            return NSLocalizedString("Could not handle the URL.", comment: "")
        case .failedToParseContents:
            return NSLocalizedString("Failed to parse the CSV. Check that it's not empty", comment: "")
        case .invalidHeader:
            return NSLocalizedString("The document contains an invalid header.", comment: "")
        case .invalidData(description: let description):
            return description
        case .invalidStyle(description: let description):
            return description
        case .invalidBottleState(description: let description):
            return description
        case .invalidOrigin(description: let description):
            return description
        case .invalidProofNumber(description: let description):
            return description
        case .invalidAgeNumber(description: let description):
            return description
        case .invalidDate(description: let description):
            return description
        case .invalidPrice(description: let description):
            return description
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    // This closure will be used to pass the Person array back to the SwiftUI view.
    var onDocumentsPicked: (Result<[Whiskey], DocumentPickerError>) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.commaSeparatedText], asCopy: true)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // You can update the controller here if needed
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(parent: self)
    }
    
    class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        var parent: DocumentPicker
        
        init(parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.onDocumentsPicked(.failure(DocumentPickerError.couldNotHandleUrl))
                return
            }
            
            do {
                let contents = try String(contentsOf: url, encoding: .utf8)
                let whiskeys = try DocumentPicker.parseCSV(contents: contents)
                parent.onDocumentsPicked(.success(whiskeys))
            } catch {
                parent.onDocumentsPicked(.failure(error as! DocumentPickerError))
            }
        }
    }
    
    static func parseCSV(contents: String) throws -> [Whiskey] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy" // Adjust to match "6/15/2023" with no leading zeros
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // U
        
        let rows = contents.components(separatedBy: "\n")
        
        /* Throw error is CSV is empty */
        guard rows.count > 1 else {
            throw DocumentPickerError.failedToParseContents
        }
        
        /* Check for expected headers */
        let headers = rows.first!.components(separatedBy: ",")
        if !DocumentPicker.isValidHeader(headers: headers) {
            throw DocumentPickerError.invalidHeader
        }
        
        let dataRows = rows.dropFirst() // Assuming first row is header
        var whiskeys: [Whiskey] = []
        for (index, row) in dataRows.enumerated() {
            var columns = row.components(separatedBy: ",")
            for column in columns {
                if column.count > 30 {
                    throw DocumentPickerError.invalidData(description: "Data in row \(index + 2) exceeds the maximum allowed length.")
                }
            }
            
            let styleValue = columns[2].trimmingCharacters(in: .whitespacesAndNewlines)
            guard Style(rawValue: styleValue) != nil else {
                throw DocumentPickerError.invalidStyle(description: "The style column should be \"Bourbon\", \"Rye\", \"Scotch\", \"Irish\", \"Tennessee\", \"Canadian\" or \"Japanese\" in row \(index + 2) in your csv.")
            }
        
            let bottleStateValue = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
            guard BottleState(rawValue: bottleStateValue) != nil else {
                throw DocumentPickerError.invalidStyle(description: "The bottleState column should be \"Sealed\", \"Open\", or \"Finished\" in row \(index + 2) in your csv.")
            }
            
            let originValue = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
            guard Origin(rawValue: originValue) != nil else {
                throw DocumentPickerError.invalidOrigin(description: "The origin column should be \"United States\", \"Scotland\", \"Ireland\", \"Canada\", \"Japan\", or \"England\" in row \(index + 2) in your csv.")
            }
            
            let proofValue = columns[6].trimmingCharacters(in: .whitespacesAndNewlines)
            let proofComponents = proofValue.components(separatedBy: ".")
            if proofComponents.count == 2 && proofComponents[1].count > 2 {
                // If there's more than one decimal place, throw an error
                throw DocumentPickerError.invalidProofNumber(description: "The 'proof' value in row \(index + 2) has more than two decimal places.")
            }
            
            let ageValue = columns[7].trimmingCharacters(in: .whitespacesAndNewlines)
            let ageComponenets = ageValue.components(separatedBy: ".")
            if ageComponenets.count == 2 && ageComponenets[1].count > 1 {
                // If there's more than one decimal place, throw an error
                throw DocumentPickerError.invalidAgeNumber(description: "The 'age' value in row \(index + 2) has more than 1 decimal places.")
            }
            
            let purchasedDate = columns[8].trimmingCharacters(in: .whitespacesAndNewlines)
            if !purchasedDate.isEmpty {
                if dateFormatter.date(from: purchasedDate) == nil {
                    throw DocumentPickerError.invalidData(description: "The purchaseDate in row \(index + 2) is not in the expected format 'mm/dd/yyyy'.")
                }
            }
            
            let dateOpened = columns[9].trimmingCharacters(in: .whitespacesAndNewlines)
            if !dateOpened.isEmpty {
                if dateFormatter.date(from: dateOpened) == nil {
                    throw DocumentPickerError.invalidDate(description: "The dateOpened in row \(index + 2) is not in the expected format 'mm/dd/yyyy'.")
                }
            }
            
            let priceValue = columns.last!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPriceString = priceValue.replacingOccurrences(of: "\\$|,", with: "", options: .regularExpression)
            if let price = Double(cleanedPriceString) {
                columns[columns.count - 1] = "\(price)"
                let updatedRow = columns.joined(separator: ",")
                if let whiskey = Whiskey(row: updatedRow) {
                    whiskeys.append(whiskey)
                } else {
                    throw DocumentPickerError.invalidPrice(description: "Invalid price format. Please follow $132.00 or 132. No need for commas")
                }
            } else {
                throw DocumentPickerError.invalidPrice(description: "Invalid price format. Please follow $132.00 or 132. No need for commas")
            }
        }
        return whiskeys
    }
    
    static func isValidHeader(headers: [String]) -> Bool {
        let expectedHeaders = ["label", "bottle", "style", "bottleState", "origin", "finish", "proof", "age", "purchasedDate", "dateOpened", "locationPurchased", "price"]
        return headers == expectedHeaders
    }
    
    static func isValidPrice(_ price: String) -> Bool {
        let pricePattern = "^\\$?\\d+(\\.\\d{2})?$"

        let priceRegex = try! NSRegularExpression(pattern: pricePattern, options: [])

        let range = NSRange(location: 0, length: price.utf16.count)
        let match = priceRegex.firstMatch(in: price, options: [], range: range)

        return match != nil
    }
}
