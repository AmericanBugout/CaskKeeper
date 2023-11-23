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
    @State private var importWasSuccess = false
    @State private var importedCollection: [Whiskey] = []
    @State private var duplicateCount: Int?
    
    var body: some View {
        List {
            Section {
                Text("You can import a JSON that you exported from CaskKeeper to bring back your whiskey collection.")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                Text("CaskKeeper will append to your existing collection.  It will not import whiskey's with duplicate ids. Your images associated with your whiskey will not be imported.")
                    .font(.custom("AsapCondensed-SemiBold", size: 18, relativeTo: .body))
            } header: {
                Text("Usage")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            }
            .listRowSeparator(.hidden)
            
            if !importWasSuccess {
                VStack {
                    Button {
                        isImporting = true
                        importWasSuccess = false
                    } label: {
                        HStack {
                            Text("Import Collection")
                                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                            
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
                        .font(.custom("AsapCondensed-SemiBold", size: 18, relativeTo: .body))
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
                        Text("\(importedCollection.count)")
                            .font(.custom("AsapCondensed-Bold", size: 22, relativeTo: .body))
                        Text("unique whiskeys found from import")
                            .font(.custom("AsapCondensed-SemiBold", size: 18, relativeTo: .body))
                    }
                    .foregroundStyle(importWasSuccess ? .green : .aluminum)
                    .opacity(importWasSuccess ? 1 : 0)
                    .scaleEffect(importWasSuccess ? 1 : 0.9)
                    .rotationEffect(importWasSuccess ? Angle(degrees: 0) : Angle(degrees: -10))
                    .offset(x: importWasSuccess ? 0 : 800, y: 0)
                    .animation(Animation.easeInOut(duration: 1), value: importWasSuccess)
                    
                    if let duplicates = duplicateCount {
                        Text("There were \(duplicates) duplicates in the import.")
                            .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                            .foregroundStyle(.aluminum)
                    }
                }
                
                
                Image(systemName: importWasSuccess ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(importWasSuccess ? .green : .aluminum)
                    .opacity(importWasSuccess ? 1 : 0)
                    .scaleEffect(importWasSuccess ? 1 : 0.9)
                    .rotationEffect(importWasSuccess ? Angle(degrees: 0) : Angle(degrees: -10))
                    .animation(Animation.smooth(duration: 2), value: importWasSuccess)
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
                            case .success(let importedWhiskeys):
                                DispatchQueue.main.async {
                                    self.importedCollection = whiskeyLibrary.importNewWhiskeys(importedWhiskeys: importedWhiskeys).newWhiskeys
                                    self.duplicateCount = whiskeyLibrary.importNewWhiskeys(importedWhiskeys: importedWhiskeys).duplicateCount
                                    self.importWasSuccess = true
                                    whiskeyLibrary.collection.append(contentsOf: importedCollection)
                                }
                            case .failure(let error):
                                self.isErrorShowing = true
                                self.errorFromImport = error
                            }
                      }
                    }
                } catch {
                    isErrorShowing = true
                    self.errorFromImport = error
                    print("Error: \(String(describing: errorFromImport?.localizedDescription))")
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Import Collection")
    }
}

#Preview {
    NavigationStack {
        ImportWhiskeyCollectionJSONView()
            .navigationTitle("Import From JSON")
            .specialNavBar()
    }
}
