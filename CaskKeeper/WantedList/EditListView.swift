//
//  EditListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/1/23.
//

import SwiftUI

struct EditListView: View {
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
                .listRowSeparator(.hidden)
                
                
            } header: {
                Text("Description")
                    .font(.customLight(size: 18))
                
            }
            
            DatePicker("Date Created", selection: $wantedList.dateCreated, in: ...Date(), displayedComponents: .date)
                .padding(.top)
                .listRowSeparator(.hidden)
            
            Section {
                ForEach($wantedList.whiskeys, id: \.self) { $whiskey in
                    NavigationLink(destination: EditWantedWhiskeyView(whiskey: whiskey)) {
                        Text(whiskey.name)
                            .font(.customRegular(size: 20))

                    }
                    .listRowSeparator(.hidden)

                }
            } header: {
                Text("Whiskeys")
                    .font(.customLight(size: 18))
            }
        }
        .navigationTitle("Edit Wanted List")
        .listStyle(.plain)
        .font(.customRegular(size: 18))
        
    }
}

#Preview {
    EditListView(wantedList: .constant(WantedList(name: "Hard to come by Ryes", style: "Rye", description: nil, whiskeys: [WhiskeyItem(name: "High West")])))
}
