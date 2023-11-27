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
    @State private var isErrorShowing = false
    @State private var errorFromImport: Error?
    @State private var importWasSuccess: Bool? = nil
    
    var body: some View {
        List {
            Section {
                Text("You can import a JSON that you exported from CaskKeeper to bring back your whiskey collection.")
                    .font(.customLight(size: 18))
                Text("CaskKeeper will append to your existing collection.  It will not import whiskey's with duplicate ids. Your images associated with your whiskey will not be imported.")
                    .font(.customSemiBold(size: 18))
            } header: {
                Text("Usage")
                    .font(.customRegular(size: 18))
            }
            .listRowSeparator(.hidden)
            
            if importWasSuccess == nil {
                VStack {
                    Button {
                        isImporting = true
                        importWasSuccess = nil
                        errorFromImport = nil
                        isErrorShowing = false
                    } label: {
                        HStack {
                            Text("Import Collection")
                                .font(.customRegular(size: 18))
                            
                            Image(systemName: "square.and.arrow.down.on.square.fill")
                        }
                        .foregroundStyle(Color.accentColor)
                        .padding(10)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top, 40)
                }
                .frame(maxWidth: .infinity)
            }
            
            
            if errorFromImport != nil {
                VStack {
                    Text("Import was not successful")
                        .font(.customSemiBold(size: 18))
                        .foregroundStyle(Color.red)
                    Text("Something went wrong.  Check that JSON is valid.")
                    Text(errorFromImport?.localizedDescription ?? "")
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.red)
                }
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
                .animation(Animation.smooth(duration: 1), value: isErrorShowing)
            }
            
            VStack {
                VStack {
                    HStack {
                        if let uniqueCount = whiskeyLibrary.importedWhiskeyCount {
                            Text("\(uniqueCount)")
                                .font(.customBold(size: 22))
                            Text("unique whiskeys found from import")
                                .font(.customSemiBold(size: 18))
                        }
                    }
                    .foregroundStyle(importWasSuccess ?? false ? .green : .aluminum)
                    .opacity(importWasSuccess ?? false ? 1 : 0)
                    .offset(x: importWasSuccess ?? false ? 0 : 800, y: 0)
                    .animation(Animation.easeInOut(duration: 1), value: importWasSuccess)
                    
                    if let duplicateCount = whiskeyLibrary.duplicateWhiskeyCountOnJSONImport {
                        Text("There were \(duplicateCount) duplicates in the import.")
                            .font(.customLight(size: 18))
                            .foregroundStyle(.aluminum)
                            .padding(.top, 1)
                    }
                }
                Image(systemName: getSystemImageName())
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(getImageColor())
                    .opacity(importWasSuccess == nil ? 0 : 1)  // Always visible
                    .scaleEffect(getImageScale())
                    .animation(.easeInOut(duration: 2), value: importWasSuccess)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
            .padding(.top)
            
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json]) { result in
                do {
                    let selectedFile: URL = try result.get()
                    if selectedFile.startAccessingSecurityScopedResource() {
                        defer {
                            selectedFile.stopAccessingSecurityScopedResource()
                        }
                        whiskeyLibrary.importWhiskeyCollectionFromJSON(fileURL: selectedFile) { result in
                            switch result {
                            case .success(let allImported):
                                whiskeyLibrary.processImportedWhiskeys(importedWhiskeys: allImported)
                                self.importWasSuccess = true
                            case .failure(let error):
                                self.isErrorShowing = true
                                self.errorFromImport = error
                            }
                        }
                    }
                } catch {
                    isErrorShowing = true
                    self.errorFromImport = error
                }
            }
        }
        .onDisappear {
            whiskeyLibrary.setCountsToNil()
        }
        .listStyle(.plain)
        .navigationTitle("Import Collection")
    }
    
    private func getSystemImageName() -> String {
        guard let importWasSuccess = importWasSuccess else { return "" }
        return importWasSuccess ? (whiskeyLibrary.duplicateWhiskeyCountOnJSONImport ?? 0 > 0 ? "exclamationmark.triangle.fill" : "checkmark.circle.fill") : "x.circle.fill"
    }
    
    private func getImageColor() -> Color {
        guard let importWasSuccess = importWasSuccess else { return .clear }
        return importWasSuccess ? (whiskeyLibrary.duplicateWhiskeyCountOnJSONImport ?? 0 > 0 ? .gray : .green) : .red
    }

    private func getImageScale() -> CGFloat {
        guard let importWasSuccess = importWasSuccess else { return 1 }  // Return the default scale if the import hasn't been attempted
        return importWasSuccess && (whiskeyLibrary.duplicateWhiskeyCountOnJSONImport ?? 0 == 0) ? 1 : 0.9
    }
}

#Preview {
    NavigationStack {
        ImportWhiskeyCollectionJSONView()
            .navigationTitle("Import From JSON")
            .specialNavBar()
    }
}
