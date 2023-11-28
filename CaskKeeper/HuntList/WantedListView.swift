//
//  HuntListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI

struct WantedListView: View {
    @State private var wantedModel = WantedListLibrary(isForTesting: true)
    @State private var addWantedViewIsShowing = true
    
    var body: some View {
        ZStack {
            List {
                
            }
            //            List(wantedModel.wantedList.indices, id: \.self) { index in
            //                let binding = $wantedModel.wantedList[index]
            //                Section {
            //                    HStack {
            //                        VStack(alignment: .leading, spacing: 5) {
            //                            Text(binding.wrappedValue.bottle)
            //                                .font(.customRegular(size: 18))
            //                            TextEditor(text: binding.notes)
            //                                .font(.customLight(size: 18))
            //                                .scrollContentBackground(.hidden)
            //                                .frame(height: 150)
            //                                .cornerRadius(5) // Optional: if you want rounded corners
            //                                .background(
            //                                    RoundedRectangle(cornerRadius: 5)
            //                                        .stroke(Color.lead, lineWidth: 1)
            //                                )
            //
            //                        }
            //                    }
            //
            //                } header: {
            //                    Text("\(index + 1). ")
            //                        .font(.customBold(size: 18))
            //                    + Text(binding.wrappedValue.label)
            //                        .font(.customBold(size: 18))
            //                }
            //                .listRowSeparator(.hidden)
            //            }
            //            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        addWantedViewIsShowing = true
                    } label: {
                        Text("Add")
                    }
                    
                }
            }
            .disabled(addWantedViewIsShowing)
            .blur(radius: addWantedViewIsShowing ? 20 : 0)
            .sheet(isPresented: $addWantedViewIsShowing) {
                NavigationStack {
                    Form {
                        Section {
                            WhiskeyEditTextField(text: $wantedModel.userCreatedList.name, placeholder: "Name")
                            Picker("Style", selection: $wantedModel.userCreatedList.style) {
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
                            TextEditor(text: $wantedModel.userCreatedList.description)
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
                                    WhiskeyEditTextField(text: $wantedModel.whiskeyItem.name, placeholder: "Add Whiskey")
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                        .listRowBackground(Color.clear)
                                        .onSubmit(of: .text) {
                                            wantedModel.addWhiskey()
                                        }
                                    Spacer()
                                    Button {
                                        wantedModel.addWhiskey()
                                    } label: {
                                        Image(systemName: "plus")
                                            .foregroundStyle(Color.regularGreen)
                                    }
                                }
                            if !wantedModel.whiskeyItemsToAdd.isEmpty {
                                LazyVStack(spacing: 10) {
                                    ForEach(wantedModel.whiskeyItemsToAdd) { whiskey in
                                        HStack {
                                            Text(whiskey.name).font(.customLight(size: 18))
                                            Text("\(whiskey.id)")
                                            Spacer()
                                            Button {
                                                wantedModel.deleteWantedWhiskey(whiskeyItem: whiskey)
                                            } label: {
                                                Image(systemName: "minus.circle")
                                                    .imageScale(.small)
                                                    .foregroundStyle(Color.red)
                                            }
                                            
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
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
    }
}

#Preview {
    WantedListView()
}
