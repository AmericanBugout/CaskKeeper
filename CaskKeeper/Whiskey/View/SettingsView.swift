//
//  SettingsView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/14/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @State private var isDeleteWhiskeysAlertShowing: Bool = false
    @State private var isCollectionDeleted = false
    @AppStorage("showImages") var showImages: Bool = true

    var body: some View {
        Form {
            Section {
                NavigationLink(destination: ExportWhiskeyCollectionJSONView()) {
                    Label("Export to JSON", systemImage: "square.and.arrow.up.fill")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                }
            } header: {
                Text("Export")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            }
            
            Section {
                NavigationLink(destination: ImportWhiskeyCSVView()) {
                    Label("Import From CSV", systemImage: "square.and.arrow.down.fill")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))

                }
                NavigationLink(destination: ImportWhiskeyCollectionJSONView()) {
                    Label("Import From Exported JSON", systemImage: "square.and.arrow.down.on.square.fill")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                }
            } header: {
                Text("Import")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            }
            
            Section {
                Button {
                    withAnimation(Animation.easeIn(duration: 1)) {
                        isDeleteWhiskeysAlertShowing = true
                    }
                } label: {
                    
                    Label {
                        Text("Delete Collection")
                            .foregroundStyle(.white)
                    } icon: {
                        Image(systemName: "trash.fill")
                    }
                }
                .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                .disabled(whiskeyLibrary.collection.isEmpty ? true : false)
                .opacity(whiskeyLibrary.collection.isEmpty ? 0.3 : 1)
            } header: {
                Text("Remove Collection")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            }
            .alert("Your whiskey collection has been deleted.", isPresented: $isCollectionDeleted, actions: {
                Button {
                    isCollectionDeleted = false
                } label: {
                    Text("OK")
                }

            })
            
            .confirmationDialog("Removal Whiskey", isPresented: $isDeleteWhiskeysAlertShowing) {
                Button(role: .destructive) {
                    whiskeyLibrary.collection.removeAll()
                    isCollectionDeleted = true
                } label: {
                    Text("Remove")
                }
            } message: {
                Text("This will remove all whiskeys in your collection. Are you sure?")
            }
            
            Section {
                Toggle("Show Images", isOn: $showImages)
            } header: {
                Text("Display")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            }


        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
