//
//  ExportWhiskeyCollectionView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/20/23.
//

import SwiftUI
import UIKit

struct ExportWhiskeyCollectionJSONView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    
    @State private var showingShareSheet = false
    @State private var fileURL: URL?
    @State private var alertMessage: String = ""
    @State private var isErrorShowing: Bool = false

    var body: some View {
        VStack {
            // Your view content...
            Button("Export as JSON") {
                whiskeyLibrary.exportWhiskeyCollectionAsJSON { result in
                    switch result {
                    case .success(let url):
                        self.fileURL = url
                        self.showingShareSheet = true
                    case .failure(let error):
                        isErrorShowing = true
                        self.alertMessage = error.localizedDescription
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                DocumentExporter(collection: whiskeyLibrary.collection) { result in
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            }
            .alert("Alert.", isPresented: $isErrorShowing, actions: {
                Button {
                    
                } label: {
                    Text("OK")
                }
            })
        }
    }
}

#Preview {
    ExportWhiskeyCollectionJSONView()
}
