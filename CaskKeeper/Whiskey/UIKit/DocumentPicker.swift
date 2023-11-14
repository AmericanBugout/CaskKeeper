//
//  DocumentPicker.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/13/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    // This closure will be used to pass the Person array back to the SwiftUI view.
    var onDocumentsPicked: ([Whiskey]) -> Void

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
            guard let url = urls.first else { return }
            
            do {
                let contents = try String(contentsOf: url, encoding: .utf8)
                let whiskeys = DocumentPicker.parseCSV(contents: contents)
                parent.onDocumentsPicked(whiskeys)
            } catch {
                // Handle the error, possibly through a user alert
            }
        }
    }
    
    static func parseCSV(contents: String) -> [Whiskey] {
        let rows = contents.components(separatedBy: "\n")
        let dataRows = rows.dropFirst() // Assuming first row is header
        return dataRows.compactMap { Whiskey(row: $0)}
    }
}
