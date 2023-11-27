//
//  HuntListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI
import Observation

@Observable
class WhiskeyToAdd {
    var label = ""
    var bottle = ""
    var notes = ""
}


struct WantedList: View {
    @State private var wantedModel = WantedWhiskeyModel(isForTesting: true)
    @State private var addWantedViewIsShowing = true
    
    var body: some View {
        ZStack {

            List(wantedModel.whiskeys) { whiskey in
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(whiskey.bottle)
                                .font(.customLight(size: 18))
                        }
                        Text(whiskey.notes)
                    }
                   
                } header: {
                    Text(whiskey.label)
                        .font(.customLight(size: 18))
                }
            }
            .listStyle(.plain)
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
                            WhiskeyEditTextField(text: $wantedModel.whiskeyToAdd.label, placeholder: "Label")
                            WhiskeyEditTextField(text: $wantedModel.whiskeyToAdd.bottle, placeholder: "Bottle")
                        } header: {
                            Text("Whiskey Details")
                                .font(.customLight(size: 18))
                        }
                        Section {
                            TextEditor(text: $wantedModel.whiskeyToAdd.notes)
                                .font(.customLight(size: 18))
                                .scrollContentBackground(.hidden)
                                .frame(height: 150)
                                
                        } header: {
                            Text("Notes")
                                .font(.customLight(size: 18))
                        } footer: {
                            Text("Add anything additional about the whiskey here.")
                        }
                    }
                    .font(.customRegular(size: 18))
                    .navigationTitle("Add Wanted Whiskey")
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
    WantedList()
}
