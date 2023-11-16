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

               
            } header: {
                Text("Data")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))

            }
            .confirmationDialog("Removal Whiskey", isPresented: $isDeleteWhiskeysAlertShowing) {
                Button(role: .destructive) {
                    whiskeyLibrary.collection.removeAll()
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
