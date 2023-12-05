//
//  SettingsView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/14/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @State private var isDeleteWhiskeysAlertShowing = false
    @State private var isCollectionDeleted = false
    @AppStorage("showImages") var showImages = true

    var body: some View {
        Form {
            Section {
                NavigationLink(destination: ExportWhiskeyCollectionJSONView()) {
                    Label("Export to JSON", systemImage: "square.and.arrow.up.fill")
                        .font(.customLight(size: 18))
                }
            } header: {
                Text("Export")
                    .font(.customRegular(size: 18))
            }
            
            Section {
                NavigationLink(destination: ImportWhiskeyCSVView()) {
                    Label("Import From CSV", systemImage: "square.and.arrow.down.fill")
                        .font(.customLight(size: 18))

                }
                NavigationLink(destination: ImportWhiskeyCollectionJSONView()) {
                    Label("Import From Exported JSON", systemImage: "square.and.arrow.down.on.square.fill")
                        .font(.customLight(size: 18))
                }
            } header: {
                Text("Import")
                    .font(.customRegular(size: 18))
            }
            
            Section {
                Button {
                    withAnimation(Animation.easeIn(duration: 1)) {
                        isDeleteWhiskeysAlertShowing = true
                    }
                } label: {
                    
                    Label {
                        Text("Delete Collection")
                            .foregroundStyle(Color.primary)
                        
                    } icon: {
                        Image(systemName: "trash.fill")
                    }
                }
                .font(.customLight(size: 18))
                .disabled(whiskeyLibrary.collection.isEmpty ? true : false)
                .opacity(whiskeyLibrary.collection.isEmpty ? 0.3 : 1)
            } header: {
                Text("Remove Collection")
                    .font(.customRegular(size: 18))
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
                    Text("Remove".capitalized)
                }
            } message: {
                Text("This will remove all whiskeys in your collection. Are you sure?".capitalized)
            }
            
            Section {
                Toggle("Show Images", isOn: $showImages)
            } header: {
                Text("Display")
                    .font(.customRegular(size: 18))
            }


        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
