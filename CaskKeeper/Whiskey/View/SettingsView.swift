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
    
    var body: some View {
        Form {
            Section {
                NavigationLink(destination: ImportWhiskeyCSVView()) {
                    Label("Import from CSV", systemImage: "square.and.arrow.down.fill")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))

                }
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
                Text("Data")
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
                    Text("Remove All")
                }
            } message: {
                Text("This will remove all whiskeys in your collection. Are you sure?")
            }

        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
