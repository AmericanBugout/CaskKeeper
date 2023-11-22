//
//  ImportWhiskeyCollectionJSONView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/21/23.
//

import SwiftUI

struct ImportWhiskeyCollectionJSONView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    
    @State private var isImporting = false
  //  @State private var selectedFile: URL?
    @State private var alertMessage = ""
    @State private var isErrorShowing = false
    @State private var importedCollection: [Whiskey] = []
    
    var body: some View {
        VStack {
            // Your view content...
            Text("\(importedCollection.count)")
            
            Button("Import JSON") {
                isImporting = true
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json]) { result in
                do {
                    let selectedFile: URL = try result.get()
                    if selectedFile.startAccessingSecurityScopedResource() {
                        defer {
                            selectedFile.stopAccessingSecurityScopedResource()
                        }
                        whiskeyLibrary.importWhiskeyCollectionFromJSON(fileURL: selectedFile) { result in
                            switch result {
                            case .success(let whiskeysFromJSON):
                                DispatchQueue.main.async {
                                    whiskeyLibrary.collection.append(contentsOf: whiskeysFromJSON)
                                    print("Import successful")
                                }
                            case .failure(let error):
                                isErrorShowing = true
                                alertMessage = error.localizedDescription
                                print("Import failed: \(error.localizedDescription)")
                            }
                    }
                 }
                } catch {
                    isErrorShowing = true
                    alertMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ImportWhiskeyCollectionJSONView()
}
