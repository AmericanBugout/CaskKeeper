//
//  CaskKeeperApp.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/8/23.
//

import SwiftUI

@main
struct CaskKeeperApp: App {
    @State private var whiskeyLibrary = WhiskeyLibrary(isForTesting: true)
    
    var body: some Scene {
        WindowGroup {
            CKTabBarView()
                .environment(\.whiskeyLibrary, whiskeyLibrary)
        }
    }
}
