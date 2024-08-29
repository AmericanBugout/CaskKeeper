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
                    .navigationBarTitleDisplayMode(.inline)

            }
            .tabItem { Image(systemName: "list.dash") }
            
            NavigationStack {
                    RandomPourView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Image(systemName: "questionmark.circle") }
            
            NavigationStack {
                WantedListView()
                    .navigationTitle("Wanted Lists")
                    .navigationBarTitleDisplayMode(.inline)
                    .specialNavBar()
                
            }
            .tabItem { Image(systemName: "scope") }
            
            NavigationStack {
                StatisticsView()
                    .navigationTitle("Statistics")
                    .navigationBarTitleDisplayMode(.inline)
                    .specialNavBar()
            }
            .tabItem { Image(systemName: "chart.pie") }
            
            NavigationStack {
                SettingsView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Image(systemName: "gear") }
        }

    }
}

#Preview {
    CKTabBarView()
}
