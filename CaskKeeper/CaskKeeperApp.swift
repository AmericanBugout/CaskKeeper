//
//  CaskKeeperApp.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/8/23.
//

import SwiftUI

@main
struct CaskKeeperApp: App {
    @StateObject private var whiskeyLibary = WhiskeyLibrary()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.whiskeyLibrary, whiskeyLibary)
        }
    }
}
