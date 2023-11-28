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
    
    @State private var itemsToAdd = [WhiskeyItem]()
    @State private var userCreatedList = UserCreatedList()
    @State private var whiskeyToAdd = WhiskeyItem()
    
    var body: some View {
        NavigationStack {
            Form {
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
                
                Section {
                    TextEditor(text: $userCreatedList.description)
                        .frame(height: 60)
                } header: {
                    Text("Add a Description (Optional)")
                        .font(.customLight(size: 18))
                    
                } footer: {
                    Text("Add a description about this list.")
                        .font(.customLight(size: 18))
                }
                
                Section {
                    HStack {
                        WhiskeyEditTextField(text: $whiskeyToAdd.name, placeholder: "Add Whiskey")
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.clear)
                            .onSubmit(of: .text) {
                                wantedListLibrary.addWhiskey()
                            }
                        Spacer()
                        Button {
                            wantedListLibrary.addWhiskey()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.regularGreen)
                        }
                    }
                    if !itemsToAdd.isEmpty {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(itemsToAdd) { whiskey in
                                HStack {
                                    Text(whiskey.name)
                                        .font(.customLight(size: 18))
                                    Spacer()
                                    Button {

                                    } label: {
                                        Image(systemName: "minus.circle")
                                            .imageScale(.small)
                                            .foregroundStyle(Color.red)
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text("Whiskey")
                        .font(.customLight(size: 18))
                }
            }
            .font(.customRegular(size: 18))
            .navigationTitle("Create Wanted List")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        
                    }
                    .font(.customSemiBold(size: 20))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        
                    }
                    .font(.customSemiBold(size: 20))
                    
                }
            }
        }
        
    }
}

#Preview {
    AddWantedListView()
}
