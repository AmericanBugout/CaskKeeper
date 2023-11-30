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
                    Picker("style", selection: $userCreatedList.style) {
                        ForEach(Style.allCases, id: \.self) { style in
                            Text(style.rawValue)
                                .font(.customRegular(size: 18))
                        }
                    }
                    .font(.customRegular(size: 18))
                } header: {
                    Text("List Info")
                        .font(.customLight(size: 18))
                }
                .listRowSeparator(.hidden)
                
                Section {
                    TextEditor(text: $userCreatedList.description)
                        .frame(height: 70)
                        .cornerRadius(5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor, lineWidth: 3).opacity(0.3)
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
                            Text(whiskey.name)
                                .frame(maxWidth: .infinity)
                                .font(.customLight(size: 18))
                        }
                        .onDelete(perform: { indexSet in
                            userCreatedList.whiskeys.remove(atOffsets: indexSet)
                        })
                        .listRowSeparator(.hidden)
                    }
                } header: {
                    VStack(alignment: .leading) {
                        Text("Whiskey")
                            .font(.customLight(size: 18))
                            .listRowSeparator(.hidden)
                        if !userCreatedList.whiskeys.isEmpty {
                            Text("The items in at the top of the list are the most sought after whiskeys.")
                                .listRowSeparator(.hidden)
                                .font(.customLight(size: 14))
                                .padding(.top, 2)
                        }
                    }
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
                        wantedListLibrary.addWantedList()
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
        withAnimation(Animation.smooth) {
            userCreatedList.whiskeys.append(whiskey)
            name = ""
        }
    }
}

#Preview {
    AddWantedListView(userCreatedList: UserCreatedList())
}
