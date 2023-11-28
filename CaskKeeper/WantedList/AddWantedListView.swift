//
//  NewWantedListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/27/23.
//

import SwiftUI
import Observation

struct AddWantedListView: View {
    @Environment(\.wantedListLibrary) private var wantedListLibrary
    @Environment(\.dismiss) var dismiss
    
    @Bindable var userCreatedList: UserCreatedList
    @State private var name = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    WhiskeyEditTextField(text: $userCreatedList.name, placeholder: "Name")
                    Picker("Style", selection: $userCreatedList.style) {
                        ForEach(Style.allCases, id: \.self) { style in
                            Text(style.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .font(.customLight(size: 18))
                    
                    
                } header: {
                    Text("List Info")
                        .font(.customLight(size: 18))
                }
                .listRowSeparator(.hidden)

                
                Section {
                    TextEditor(text: $userCreatedList.description)
                        .frame(height: 70)
                        .cornerRadius(5) // Optional: if you want rounded corners
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.lead, lineWidth: 1)
                                //.padding(.horizontal, 10)// Optional: if you want a border around the TextEditor
                        )
                } header: {
                    Text("Add a Description (Optional)")
                        .font(.customLight(size: 18))

                    
                }
                .listRowSeparator(.hidden)

                
                Section {
                    HStack {
                        WhiskeyEditTextField(text: $name, placeholder: "Add Whiskey")
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.clear)
                            .onSubmit(of: .text) {
                                addWhiskeyToUserCreatedWantedWhiskeys()
                            }
                        Spacer()
                        Button {
                            addWhiskeyToUserCreatedWantedWhiskeys()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.regularGreen)
                        }
                    }
                    .listRowSeparator(.hidden)

                    if !userCreatedList.whiskeys.isEmpty {
                        ForEach(userCreatedList.whiskeys) { whiskey in
                            HStack {
                                Text(whiskey.name)
                                    .font(.customLight(size: 18))
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: { indexSet in
                            userCreatedList.whiskeys.remove(atOffsets: indexSet)
                        })
                    }
                } header: {
                    Text("Whiskey")
                        .font(.customLight(size: 18))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.customSemiBold(size: 20))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        // addList()
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.customSemiBold(size: 20))
                    }
                }
            }
            .font(.customRegular(size: 18))
            .navigationTitle("Create Wanted List")
        }
    }
    
    private func addWhiskeyToUserCreatedWantedWhiskeys() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        let whiskey = WhiskeyItem(name: trimmedName)
        userCreatedList.whiskeys.append(whiskey)
        name = ""
    }
    
    private func deleteWhiskeysFromUserCreatedWantedWhiskeys(id: UUID) {
        if let index = userCreatedList.whiskeys.firstIndex(where: {$0.id == id}) {
            userCreatedList.whiskeys.remove(at: index)
        }
    }
}



//    private func addList() {
//        let userCreatedList = WantedList(userCreatedList: WantedList(name: userCreatedList.name, style: userCreatedList.style.rawValue, description: userCreatedList.description, whiskeys: itemsToAdd))
//        wantedListLibrary.addWantedList(userCreatedList: userCreatedList)
//    }


#Preview {
    AddWantedListView(userCreatedList: UserCreatedList())
}
