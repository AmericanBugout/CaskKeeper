//
//  WantedListDetailView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/28/23.
//

import SwiftUI

struct WantedListDetailView: View {
    @Environment(\.wantedListLibrary) private var wantedWhiskeyLibrary

    
    @State private var internalWantedWhiskeys: [WhiskeyItem]
    @State private var internalFoundWhiskeys: [WhiskeyItem]
    
    init(wantedWhiskeys: [WhiskeyItem], foundWhiskeys: [WhiskeyItem]) {
        _internalWantedWhiskeys = State(initialValue: wantedWhiskeys)
        _internalFoundWhiskeys = State(initialValue: foundWhiskeys)
    }
    
    var body: some View {
        VStack {
            WhiskeySectionView(title: "Wanted", items: $internalWantedWhiskeys) { whiskey in
                whiskey.state = .found
                whiskey.endSearchDate = Date()
                internalFoundWhiskeys.append(whiskey)
                internalWantedWhiskeys.removeAll { $0.id == whiskey.id }
                
            }
            Spacer(minLength: 100)
            WhiskeySectionView(title: "Found", items: $internalFoundWhiskeys) { whiskey in
                whiskey.state = .looking
                internalWantedWhiskeys.append(whiskey)
                internalFoundWhiskeys.removeAll {$0.id == whiskey.id}
            }
            
            Spacer()
        }
    }
}


#Preview {
    NavigationStack {
        WantedListDetailView(wantedWhiskeys: [WhiskeyItem(name: "Mid Winter Nights Dram")], foundWhiskeys: [WhiskeyItem(name: "Four Roses OBSF")])
    }
}
