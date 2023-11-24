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
    
    @State private var showingingDocumentExporter = false
    @State private var exportWasSuccessful = false
    @State private var exportError: Error?
    @State private var showErrorAlert = false
    
    var body: some View {
        List {
            Section {
                Text("CaskKeeper allows you to export your whiskey collection as a JSON file.")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                Text("This should be used when you want to backup your collection.  This is the file that will be used when importing from JSON.")
                    .font(.custom("AsapCondensed-SemiBold", size: 18, relativeTo: .body))
            } header: {
                Text("Usage")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            }
            .listRowSeparator(.hidden)
            
            VStack(alignment: .center) {
                HStack(spacing: 20) {
                    Text("Collection Count")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                    Text("\(whiskeyLibrary.collectionCount)")
                        .font(.custom("AsapCondensed-Bold", size: 42, relativeTo: .body))
                        .foregroundStyle(Color.accentColor)
                }
            }
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity)
            .padding()
            
            if !exportWasSuccessful {
                VStack {
                    Button {
                        exportWasSuccessful = false
                        showingingDocumentExporter = true
                    } label: {
                        HStack {
                            Text("Export to JSON")
                                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                            
                            Image(systemName: "square.and.arrow.up.fill")
                        }
                        .foregroundStyle(Color.accentColor)
                        .padding(10)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .disabled(exportWasSuccessful ? true : false)
                .opacity(exportWasSuccessful ? 0 : 1)
                .listRowSeparator(.hidden)
            }
            
            if exportError != nil {
                VStack {
                    Text("Error on Export")
                        .font(.custom("AsapCondensed-SemiBold", size: 18, relativeTo: .body))
                        .foregroundStyle(Color.red)
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.red)
                }
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
            }
            
            VStack {
                Text("Export Successful")
                    .font(.custom("AsapCondensed-SemiBold", size: 18, relativeTo: .body))
                    .foregroundStyle(exportWasSuccessful ? .green : .aluminum)
                    .opacity(exportWasSuccessful ? 1 : 0)
                    .scaleEffect(exportWasSuccessful ? 1 : 0.9)
                    .rotationEffect(exportWasSuccessful ? Angle(degrees: 0) : Angle(degrees: -10))
                    .offset(x: exportWasSuccessful ? 0 : 800, y: 0)
                    .animation(Animation.easeInOut(duration: 1), value: exportWasSuccessful)
                Image(systemName: exportWasSuccessful ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(exportWasSuccessful ? .green : .aluminum)
                    .opacity(exportWasSuccessful ? 1 : 0)
                    .scaleEffect(exportWasSuccessful ? 1 : 0.9)
                    .rotationEffect(exportWasSuccessful ? Angle(degrees: 0) : Angle(degrees: -10))
                    .offset(x: exportWasSuccessful ? 0 : -800, y: 0)
                    .animation(Animation.smooth(duration: 2), value: exportWasSuccessful)
            }
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)

            .sheet(isPresented: $showingingDocumentExporter) {
                DocumentExporter(collection: whiskeyLibrary.collection) { result in
                    switch result {
                    case .success:
                        showingingDocumentExporter = false
                        exportWasSuccessful = true
                    case .failure(let error):
                        exportError = error
                        showingingDocumentExporter = false
                        exportWasSuccessful = false
                    }
                }
            }
            .alert("Export Failed", isPresented: $showErrorAlert) {
                Button {
                    showingingDocumentExporter = false
                    exportWasSuccessful = false
                    exportError = nil
                } label: {
                    Text("Ok")
                }
            }
        }
        .listStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Export Collection")
    }
}

#Preview {
    NavigationStack {
        ExportWhiskeyCollectionJSONView()
            .navigationTitle("Export Collection")
            .specialNavBar()
    }
}
