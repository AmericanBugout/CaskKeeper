//
//  HuntListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI

struct WantedListView: View {
    @State private var addWantedViewIsShowing = false
    @State private var wantedListLibrary = WantedListLibrary(isForTesting: false)
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }
    
    var body: some View {
        ZStack {
            
            List {
                if let lists = wantedListLibrary.groupedLists {
                    if lists.isEmpty {
                        ZStack {
                            Text("No lists created.")
                                .font(.customBold(size: 26))
                                .foregroundStyle(.aluminum)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        }
                        .frame(height: 500)
                        .listRowSeparator(.hidden)
                    }
                    ForEach(lists, id: \.key) { group in
                        Section(header: Text(group.key).font(.customRegular(size: 18))) {
                            ForEach(group.list, id: \.id) { list in
                                NavigationLink {
                                    WantedListDetailView(wantedWhiskeys: list.whiskeys ?? [], foundWhiskeys: list.foundWhiskeys ?? []) { whiskey in
                                        wantedListLibrary.updateWhiskey(whiskey: whiskey, inList: list.id)
                                    }
                                    .toolbar {
                                        ToolbarItem(placement: .principal) {
                                            HStack(alignment: .top, spacing: 0) {
                                                Text("Created on ")
                                                    .font(.customLight(size: 12))
                                                let formatted = dateFormatter.string(from: list.dateCreated)
                                                Text(formatted)
                                                    .font(.customRegular(size: 12))
                                            }
                                        }
                                    }
                                    .environment(\.wantedListLibrary, wantedListLibrary)
                                    .navigationTitle("Wanted Whiskeys")
                                } label: {
                                    Text(list.name)
                                        .font(.customRegular(size: 18))
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addWantedViewIsShowing = true
                    } label: {
                        Text("New List")
                            .font(.customRegular(size: 16))
                    }
                    
                }
            }
            .disabled(addWantedViewIsShowing)
            .blur(radius: addWantedViewIsShowing ? 20 : 0)
            .sheet(isPresented: $addWantedViewIsShowing) {
                AddWantedListView(userCreatedList: wantedListLibrary.userCreatedList)
                    .environment(\.wantedListLibrary, wantedListLibrary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        WantedListView()
            .navigationTitle("Wanted Lists")
    }
}
