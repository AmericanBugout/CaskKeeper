//
//  EditWantedWhiskeyView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/2/23.
//

import SwiftUI

struct EditWantedWhiskeyView: View {
    @Bindable var whiskey: WhiskeyItem
    
    @State private var isNeedToSetStateToFound = false
    
    var body: some View {
        List {
            Section {
                WhiskeyEditTextField(text: $whiskey.name, placeholder: "Name")
                    .listRowSeparator(.hidden)
                toggleStateView(whiskey: whiskey)
                DatePicker("Date Found", selection: Binding<Date>(
                    get: { whiskey.endSearchDate ?? Date() },
                    set: { whiskey.endSearchDate = $0 }
                ), 
                in: ...Date(),
                displayedComponents: .date)
                .onChange(of: whiskey.endSearchDate, { oldValue, newValue in
                    if let _ = newValue {
                        withAnimation(Animation.easeOut(duration: 0.5)) {
                            whiskey.state = .found
                        }
                    }
                })
                .listRowSeparator(.hidden)
                WhiskeyEditTextField(text: Binding<String>(
                    get: { whiskey.location ?? "" },
                    set: { newValue in
                        whiskey.location = newValue
                        if !newValue.isEmpty {
                            whiskey.state = .found
                        }
                    }
                ), placeholder: "Location")
                .listRowSeparator(.hidden)
                .alert("Cannot submit location while having Looking state", isPresented: $isNeedToSetStateToFound) {
                    Button("Error", role: .cancel) {
                        isNeedToSetStateToFound = false
                    }
                }
            } header: {
                Text("Whiskey Details")
            }
        }
        .listStyle(.plain)
        .navigationTitle("Edit")
    }
    
    
    func updateLocation(newLocation: String) {
        if whiskey.state == .found {
            whiskey.location = newLocation
        } else if !isNeedToSetStateToFound {
            isNeedToSetStateToFound = true
        }
    }
    
    private func toggleStateView(whiskey: WhiskeyItem) -> some View {
        HStack {
            Text(whiskey.state.currentState)
                .font(.customRegular(size: 20))
            Spacer()
            Button {
                withAnimation(Animation.easeOut(duration: 0.5)) {
                    switch whiskey.state {
                    case .looking:
                        whiskey.state = .found
                        whiskey.endSearchDate = Date()
                    case .found:
                        whiskey.state = .looking
                        whiskey.endSearchDate = nil
                        whiskey.location = nil
                    }
                }
            } label: {
                Image(systemName: whiskey.state == .looking ? "circle" : "checkmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundStyle(whiskey.state == .looking ? Color.aluminum : Color.regularGreen)
            }
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    EditWantedWhiskeyView(whiskey: (WhiskeyItem(name: "WNDM")))
}
