//
//  EditListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/1/23.
//

import SwiftUI

struct EditListView: View {
    @Environment(\.wantedListLibrary) var wantedListLibrary

    let groupIndex: Int
    @Binding var wantedList: WantedList
    
    var body: some View {
        List {
            Section {
                WhiskeyEditTextField(text: $wantedList.name, placeholder: "Name")
                    .listRowSeparator(.hidden)
                    .font(.customRegular(size: 20))
                Picker("style", selection: $wantedList.style) {
                    ForEach(Style.allCases, id: \.self) { style in
                        Text(style.rawValue)
                            .tag(style.rawValue)
                            .font(.customRegular(size: 20))
                    }
                }
                .font(.customRegular(size: 20))
                .listRowSeparator(.hidden)
            }header: {
                Text("List Name")
                    .font(.customLight(size: 18))
            }
            
            Section {
                TextEditor(text: Binding<String>(
                    get: { wantedList.description ?? ""},
                    set: { wantedList.description = $0 }
                    
                ))
                .frame(height: 70)
                .font(.customRegular(size: 20))
            } header: {
                Text("Description")
                    .font(.customLight(size: 18))
            }
            
            DatePicker("Date Created", selection: $wantedList.dateCreated, in: ...Date(), displayedComponents: .date)
                .listRowSeparator(.hidden)
            
            Section {
                ForEach($wantedList.whiskeys, id: \.self) { $whiskey in
                    NavigationLink {
                        EditWantedWhiskeyView(list: wantedList, groupIndex: groupIndex, whiskey: whiskey)
                            .environment(\.wantedListLibrary, wantedListLibrary)
                    } label: {
                        Text(whiskey.name)
                            .font(.customRegular(size: 20))
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            } header: {
                Text("Whiskeys")
                    .font(.customLight(size: 18))
            }
        }
        .onDisappear {
            wantedListLibrary.saveWhiskeyList(groupIndex: groupIndex, list: wantedList)
        }
//        .toolbar(content: {
//            ToolbarItem(placement: .confirmationAction) {
//                Button("Save") {
//                    wantedListLibrary.saveWhiskeyList(groupIndex: groupIndex, list: wantedList)
//                }
//                .font(.customBold(size: 20))
//            }
//        })
        .navigationTitle("Edit Wanted List")
        .font(.customRegular(size: 18))
        
    }
}

#Preview {
    EditListView(groupIndex: 2, wantedList: .constant(WantedList(name: "Hard to gets", style: "Bourbon", description: "No description", whiskeys: [WhiskeyItem(name: "High WestMNWD")])))
}
