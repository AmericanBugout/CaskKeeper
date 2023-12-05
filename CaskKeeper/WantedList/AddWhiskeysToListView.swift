//
//  AddWhiskeysToListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/4/23.
//

import SwiftUI

struct AddWhiskeysToListView: View {
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var whiskeysToAdd: [WhiskeyItem] = []
    @State private var isEmptyNameAlertShowing = false
    
    var onAdd: ([WhiskeyItem]) -> Void
    
    init(onAdd: @escaping ([WhiskeyItem]) -> Void) {
        self.onAdd = onAdd
    }
        
    var body: some View {
        List {
            Section {
                HStack {
                    WhiskeyEditTextField(text: $name, placeholder: "Add Whiskey")
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        .onSubmit(of: .text) {
                            addWhiskeyToUserCreatedWantedWhiskeys()
                        }
                        .alert("Name cannot be empty", isPresented: $isEmptyNameAlertShowing) {
                            Button("Ok") {
                                isEmptyNameAlertShowing = false
                            }
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
                .alert("Empty Field", isPresented: $isEmptyNameAlertShowing) {
                    Button {
                        isEmptyNameAlertShowing = false
                    } label: {
                        Text("Ok")
                    }

                } message: {
                    Text("Your list name cannot be empty.")
                }

            } header: {
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.customLight(size: 18))
                        .listRowSeparator(.hidden)
                }
            }
            
            Section {
                if !whiskeysToAdd.isEmpty {
                    ForEach(whiskeysToAdd) { whiskey in
                        Text(whiskey.name)
                            .frame(maxWidth: .infinity)
                            .font(.customLight(size: 18))
                    }
                    .onDelete(perform: { indexSet in
                        whiskeysToAdd.remove(atOffsets: indexSet)
                    })
                    .listRowSeparator(.hidden)
                }
              
            } header: {
                VStack(alignment: .leading) {
                    Text("Whiskeys to add")
                        .font(.customLight(size: 18))
                        .listRowSeparator(.hidden)
                    if !whiskeysToAdd.isEmpty {
                        Text("The items in at the top of the list are the most sought after whiskeys.")
                            .listRowSeparator(.hidden)
                            .font(.customLight(size: 14))
                            .padding(.top, 2)
                    }
                }
            }

        }
        .navigationTitle("Add Whiskeys")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onAdd(whiskeysToAdd)
                    dismiss()
                }
            }
        }
    }
    
    private func addWhiskeyToUserCreatedWantedWhiskeys() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        let whiskey = WhiskeyItem(name: trimmedName)
        withAnimation(Animation.smooth) {
            whiskeysToAdd.append(whiskey)
            name = ""
        }
    }
}

#Preview {
    AddWhiskeysToListView { whiskeys in
        
    }
}
