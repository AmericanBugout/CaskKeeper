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
                Picker("style", selection: $wantedList.style) {
                    ForEach(Style.allCases, id: \.self) { style in
                        Text(style.rawValue)
                            .font(.customRegular(size: 18))
                    }
                }
                .font(.customRegular(size: 18))
                .listRowSeparator(.hidden)
            }header: {
                Text("Edit List Details")
                    .font(.customLight(size: 18))
            }
            
            Section {
                TextEditor(text: Binding<String>(
                    get: { wantedList.description ?? ""},
                    set: { wantedList.description = $0 }
                    
                ))
                .frame(height: 70)
                .cornerRadius(5)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentColor, lineWidth: 3).opacity(0.3)
                )
                .font(.customRegular(size: 18))
                .listRowSeparator(.hidden)
                
                
            } header: {
                Text("Description")
                    .font(.customLight(size: 18))
                
            }
            
            DatePicker("Date Created", selection: $wantedList.dateCreated, displayedComponents: .date)
                .padding(.top)
                .listRowSeparator(.hidden)
            
            Section {
                LazyVGrid(columns: [GridItem()]) {
                    ForEach($wantedList.whiskeys) { whiskey in
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                WhiskeyEditTextField(text: whiskey.name, placeholder: "Name")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button {
                                    withAnimation(Animation.smooth) {
                                        switch whiskey.state.wrappedValue {
                                        case .looking:
                                            whiskey.state.wrappedValue = .found
                                        case .found:
                                            whiskey.state.wrappedValue = .looking
                                        }
                                    }
                                } label: {
                                    Image(systemName: whiskey.state.wrappedValue == .looking ? "circle" : "checkmark.circle.fill")
                                        .imageScale(.medium)
                                        .foregroundStyle(whiskey.state.wrappedValue == .looking ? Color.aluminum : Color.regularGreen)
                                }

                            }
                            
                            DatePicker("Found Date:", selection: Binding<Date>(
                                get: { whiskey.endSearchDate.wrappedValue ?? Date() },
                                set: { whiskey.endSearchDate.wrappedValue = $0 }
                            ), displayedComponents: .date)
                            .datePickerStyle(DefaultDatePickerStyle())
                            .scaleEffect(1)
                            WhiskeyEditTextField(text: Binding<String>(
                                get: { whiskey.location.wrappedValue ?? ""},
                                set: { whiskey.location.wrappedValue = $0 }
                            ), placeholder: "Location")
                        }
                    }
                }
            } header: {
                Text("Edit Whiskeys")
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
