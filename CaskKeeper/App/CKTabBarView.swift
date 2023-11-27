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
            ContentView()
                .tabItem { Image(systemName: "list.dash") }
            Text("NextView")
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
