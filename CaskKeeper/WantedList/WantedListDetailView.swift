//
//  WantedListDetailView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/28/23.
//

import SwiftUI

enum HuntState {
    case searching
    case found
}

struct WantedListDetailView: View {
    @Environment(\.wantedListLibrary) private var wantedWhiskeyLibrary
    
    @State private var internalWantedWhiskeys: [WhiskeyItem]
    @State private var internalFoundWhiskeys: [WhiskeyItem]
    @State private var searching: HuntState = .searching
    var onChange: (WhiskeyItem) -> Void
    
    init(wantedWhiskeys: [WhiskeyItem], foundWhiskeys: [WhiskeyItem], onChange: @escaping (WhiskeyItem) -> Void) {
        _internalWantedWhiskeys = State(initialValue: wantedWhiskeys)
        _internalFoundWhiskeys = State(initialValue: foundWhiskeys)
        self.onChange = onChange
    }
    
    var body: some View {
        ZStack {
            List {
                WhiskeySectionView(title: "Wanted", items: $internalWantedWhiskeys) { whiskey in
                    whiskey.state = .found
                    whiskey.endSearchDate = Date()
                    internalFoundWhiskeys.append(whiskey)
                    internalWantedWhiskeys.removeAll { $0.id == whiskey.id }
                    onChange(whiskey)
                }
                .listRowSeparator(.hidden)
            }
            .opacity(searching == .searching ? 1 : 0)
            .offset(x: searching == .found ? 800 : 0, y: 0)
            .animation(Animation.easeOut(duration: 1), value: searching)
            .listStyle(.plain)
            
            List {
                WhiskeySectionView(title: "Found", items: $internalFoundWhiskeys) { whiskey in
                    whiskey.state = .looking
                    whiskey.endSearchDate = nil
                    internalWantedWhiskeys.append(whiskey)
                    internalFoundWhiskeys.removeAll {$0.id == whiskey.id}
                    onChange(whiskey)
                }
                .listRowSeparator(.hidden)
            }
            .opacity(searching == .found ? 1 : 0)
            .offset(x: searching == .searching ? -800 : 0, y: 0)
            .animation(Animation.spring, value: searching)
            .listStyle(.plain)
        }
        .navigationTitle(searching == .found ? "Found" : "Wanted")
        
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    switch searching {
                    case .searching:
                        searching = .found
                    case .found:
                        searching = .searching
                    }
                } label: {
                    Image(systemName: "switch.2")
                }
                .animation(Animation.smooth(duration: 1), value: searching)

            }
        }
    }
    
}


#Preview {
    NavigationStack {
        WantedListDetailView(wantedWhiskeys: [WhiskeyItem(name: "Mid Winter Nights Dram")], foundWhiskeys: [WhiskeyItem(name: "Four Roses OBSF")]) { _ in
            
        }
    }
}
