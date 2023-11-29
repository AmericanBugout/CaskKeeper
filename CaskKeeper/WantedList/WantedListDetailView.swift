//
//  WantedListDetailView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/28/23.
//

import SwiftUI

struct WantedListDetailView: View {
    let wantedList: WantedList
    
    @State private var modifiedWhiskeys: [WhiskeyItem]
    @State private var foundWhiskeys: [WhiskeyItem] = []
    
    init(wantedList: WantedList) {
        self.wantedList = wantedList
        self._modifiedWhiskeys = State(initialValue: wantedList.whiskeys ?? [])
    }
    
    var body: some View {
        List {
            Section {
                ForEach(modifiedWhiskeys.indices, id: \.self) { index in
                    HStack {
                        Text("\(index + 1). ")
                        if modifiedWhiskeys[index].state == .looking {
                            Text(modifiedWhiskeys[index].name)
                            Spacer()
                            Button {
                                withAnimation(Animation.smooth(duration: 1)) {
                                    foundWhiskeys.append(modifiedWhiskeys[index])
                                    print(modifiedWhiskeys[index].name)
                                    modifiedWhiskeys.remove(at: index)
                                }
                            } label: {
                                Image(systemName: modifiedWhiskeys[index].state == .looking ? "circle" : "checkmark.circle.fill")
                            }
                        }
                    }
                }
                .onMove { sourceIndices, destinationIndex in
                    modifiedWhiskeys.move(fromOffsets: sourceIndices, toOffset: destinationIndex)
                }
                .listRowSeparator(.hidden)
                
            } header: {
                Text("Looking")
            }
            
            
            Section {
                ForEach(foundWhiskeys.indices, id: \.self) { index in
                    HStack {
                        Text(foundWhiskeys[index].name)
                        Spacer()
                        Button {
                            withAnimation(Animation.smooth(duration: 1)) {
                                let whiskeyToAddBack = foundWhiskeys[index]
                                modifiedWhiskeys.append(whiskeyToAddBack)
                                foundWhiskeys.remove(at: index)
                            }
                        } label: {
                            Image(systemName: foundWhiskeys[index].state == .looking ? "checkmark.circle.fill" : "circle")
                        }
                    }
                }
            } header: {
                Text("Found")
            }
            
        }
        .listStyle(.plain)
        .navigationTitle(wantedList.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
            ToolbarItem(placement: .principal) {
                Text(wantedList.style)
                    .font(.customBold(size: 26))
            }
        }
    }
}


#Preview {
    NavigationStack {
        WantedListDetailView(wantedList: WantedList(name: "Super Rare Ryes", style: "Rye", description: "Been targeting these for 5 years", whiskeys: [
            WhiskeyItem(name: "High West MNWD"),
            WhiskeyItem(name: "Double Rendevous")
        ]))
    }
}
