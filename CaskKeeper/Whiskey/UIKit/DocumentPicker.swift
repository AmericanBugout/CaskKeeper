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
    
    var errorDescription: String? {
        switch self {
        case .couldNotHandleUrl:
            return NSLocalizedString("Could not handle the URL.", comment: "")
        case .failedToParseContents:
            return NSLocalizedString("Failed to parse the CSV. Check that it's not empty", comment: "")
        case .invalidHeader:
            return NSLocalizedString("The document contains an invalid header.", comment: "")
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    // This closure will be used to pass the Person array back to the SwiftUI view.
    var onDocumentsPicked: (Result<[Whiskey], Error>) -> Void

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
                // Handle the error, possibly through a user alert
                parent.onDocumentsPicked(.failure(error))
            }
        }
    }
    
    static func parseCSV(contents: String) throws -> [Whiskey] {
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
        return dataRows.compactMap { Whiskey(row: $0)}
    }
    
    static func isValidHeader(headers: [String]) -> Bool {
        let expectedHeaders = ["label", "bottle", "style", "bottleState", "origin", "finish", "proof", "age", "purchasedDate", "dateOpened", "locationPurchased", "price"]
        return headers == expectedHeaders
    }
}
