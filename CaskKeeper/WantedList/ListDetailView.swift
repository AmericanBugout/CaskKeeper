//
//  ListDetailView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/30/23.
//

import SwiftUI

struct ListDetailView: View {
    @Environment(\.wantedListLibrary) var wantedListLibrary
    @State private var refreshFlag = false
    @State private var editListViewShowing = false
    
    let groupIndex: Int
    
    @State private var list: WantedList
    @State private var internalWhiskeys: [WhiskeyItem]
    @State private var showingLookingList = true
        
    let transitionAnimation: Animation = .interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5)
    
    private var lookingWhiskeys: [WhiskeyItem] {
        internalWhiskeys.filter { $0.state == .looking }
    }
    
    private var foundWhiskeys: [WhiskeyItem] {
        internalWhiskeys.filter { $0.state == .found }
    }
    
    init(groupIndex: Int, list: WantedList) {
        self._list = State(initialValue: list)
        self._internalWhiskeys = State(initialValue: list.whiskeys)
        self.groupIndex = groupIndex
    }
    
    var body: some View {
        ZStack {
            if showingLookingList {
                listView(whiskeys: lookingWhiskeys)
                    .transition((.asymmetric(insertion: .opacity.combined(with: .scale), removal: .slide)))
            } else {
                listView(whiskeys: foundWhiskeys)
                    .transition((.asymmetric(insertion: .opacity.combined(with: .scale), removal: .slide)))
            }
        }
        .animation(transitionAnimation, value: showingLookingList)
        .navigationTitle(showingLookingList ? "Wanted" : "Found")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                HStack {
                    NavigationLink {
                        EditListView(groupIndex: groupIndex, wantedList: $list)
                            .environment(\.wantedListLibrary, wantedListLibrary)
                        } label: {
                            Text("Edit")
                        }
                    Button {
                        showingLookingList.toggle()
                    } label: {
                        Image(systemName: "switch.2")
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                Text(list.name)
            }
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        internalWhiskeys.move(fromOffsets: source, toOffset: destination)
        wantedListLibrary.updateWhiskeysInList(groupIndex: groupIndex, list: list, whiskeysToSave: internalWhiskeys)
    }

    private func toggleWhiskeyState(at index: Int) {
        withAnimation(Animation.smooth) {
            switch internalWhiskeys[index].state {
            case .looking:
                internalWhiskeys[index].state = .found
                internalWhiskeys[index].endSearchDate = Date()
                wantedListLibrary.updateWhiskeysInList(groupIndex: groupIndex, list: list, whiskeysToSave: internalWhiskeys)
            case .found:
                internalWhiskeys[index].state = .looking
                internalWhiskeys[index].endSearchDate = nil
                internalWhiskeys[index].location = nil
                wantedListLibrary.updateWhiskeysInList(groupIndex: groupIndex, list: list, whiskeysToSave: internalWhiskeys)
            }
        }
    }
    
    private func whiskeyRow(whiskey: WhiskeyItem, index: Int) -> some View {
        VStack(spacing: 5) {
            HStack(alignment: .top) {
                if showingLookingList {
                    Text("\(index + 1). ")
                        .font(.customRegular(size: 18))
                }
                Text(whiskey.name)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Spacer()
                handleStateButton(whiskey: whiskey)
            }
            .font(.customRegular(size: 20))

            
            if let endDate = whiskey.endSearchDate {
                HStack {
                    VStack {
                        Text("Found on ")
                        + Text(endDate, style: .date)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.customLight(size: 14))
                    .foregroundStyle(Color.accentColor)
                    .opacity(0.8)
                    
                    if let location = whiskey.location {
                        Text(location)
                            .font(.customRegular(size: 16))
                    }
                    Spacer()
                }
            }
        }
        .padding(.top, 5)
        .listRowSeparator(.hidden)
    }
    
    @ViewBuilder
    private func handleStateButton(whiskey: WhiskeyItem) -> some View {
        Button {
            if let index = internalWhiskeys.firstIndex(where: { $0.id == whiskey.id }) {
                toggleWhiskeyState(at: index)
            }
        } label: {
            Image(systemName: whiskey.state == .looking ? "circle" : "checkmark.circle.fill")
                .imageScale(.medium)
                .foregroundStyle(whiskey.state == .looking ? Color.aluminum : Color.regularGreen)
        }
    }
    
    @ViewBuilder 
    func listView(whiskeys: [WhiskeyItem]) -> some View {
        List {
            ForEach(whiskeys.indices, id: \.self) { index in
                whiskeyRow(whiskey: whiskeys[index], index: index)
            }
            .onDelete { indexSet in
                internalWhiskeys.remove(atOffsets: indexSet)
                refreshFlag.toggle()
                wantedListLibrary.updateWhiskeysInList(groupIndex: groupIndex, list: list, whiskeysToSave: internalWhiskeys)
            }
            .onMove(perform: move)
        }
    }
}

#Preview {
    ListDetailView(groupIndex: 1, list: WantedList(name: "Best ryes in the world", style: "Rye", description: nil, whiskeys: [WhiskeyItem(name: "High West"), WhiskeyItem(name: "Wild Turkey")]))
}
