//
//  DocumentExporter.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/20/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentExporter: UIViewControllerRepresentable {
    var collection: [Whiskey]
    var onExportCompleted: (Result<URL, Error>) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("WhiskeyCollection.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            
            let jsonData = try encoder.encode(collection)
            try jsonData.write(to: tempURL, options: .atomic)
            let picker = UIDocumentPickerViewController(forExporting: [tempURL])
            picker.delegate = context.coordinator
            return picker
        } catch {
            onExportCompleted(.failure(error))
            return UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json])
        }
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        var parent: DocumentExporter

        init(_ documentExporter: DocumentExporter) {
            self.parent = documentExporter
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onExportCompleted(.success(urls[0]))
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

        }
    }
}
