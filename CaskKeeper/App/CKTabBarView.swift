//
//  CKTabBarView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI

struct CKTabBarView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ContentView()
                    .navigationTitle("Collection")
            }
            .tabItem { Image(systemName: "list.dash") }
            
            NavigationStack {
                WantedListView()
                    .navigationTitle("Wanted Whiskeys")
            }
            .tabItem { Image(systemName: "scope") }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem { Image(systemName: "gear") }
            
        }
    }
}

#Preview {
    CKTabBarView()
}
