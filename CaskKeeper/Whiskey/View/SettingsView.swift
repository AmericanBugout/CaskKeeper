//
//  SettingsView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/14/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section {
                NavigationLink(destination: ImportWhiskeyCSVView()) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .imageScale(.large)
                        .foregroundStyle(.accent)
                    Text("Import Whiskey from CSV")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))

                }
            } header: {
                Text("Data")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))

            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
