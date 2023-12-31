//
//  EnvironmentValues+Ext.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/7/23.
//

import SwiftUI

extension EnvironmentValues {
    var whiskeyLibrary: WhiskeyLibrary {
        get { self[WhiskeyLibraryKey.self] }
        set { self[WhiskeyLibraryKey.self] = newValue }
    }
    
    var flavorCatalog: FlavorCatalog {
        get { self[FlavorCatalogKey.self] }
        set { self[FlavorCatalogKey.self] = newValue }
    }
    
    var wantedListLibrary: WantedListLibrary {
        get { self[WantedListKey.self] }
        set { self[WantedListKey.self] = newValue }
    }
}

private struct WhiskeyLibraryKey: EnvironmentKey {
    static var defaultValue: WhiskeyLibrary = WhiskeyLibrary()
}

private struct FlavorCatalogKey: EnvironmentKey {
    static var defaultValue: FlavorCatalog = FlavorCatalog()
}

private struct WantedListKey: EnvironmentKey {
    static var defaultValue: WantedListLibrary = WantedListLibrary()
}

struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
