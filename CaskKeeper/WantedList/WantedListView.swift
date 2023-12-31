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
        List {
            if let lists = wantedListLibrary.groupedLists, !lists.isEmpty {
                ForEach(lists.indices, id: \.self) { groupIndex in
                    let group = lists[groupIndex]
                    Section(header: Text(group.key).font(.customRegular(size: 18))) {
                        ForEach(group.list, id: \.id) { list in
                            NavigationLink {
                                ListDetailView(groupIndex: groupIndex, list: list)
                                    .environment(\.wantedListLibrary, wantedListLibrary)
                            } label: {
                                ListRowView(name: list.name, total: list.whiskeys.count, found: list.foundCount, wanted: list.wantedCount)
                            }
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            wantedListLibrary.deleteItem(groupIndex: groupIndex, itemIndexSet: indexSet)
                        }
                    }
                }
            } else {
                ZStack {
                    Text("No lists created.")
                        .font(.customLight(size: 22))
                        .foregroundStyle(.aluminum)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 500)
                .listRowSeparator(.hidden)
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
        .sheet(isPresented: $addWantedViewIsShowing) {
            AddWantedListView(userCreatedList: wantedListLibrary.userCreatedList)
                .environment(\.wantedListLibrary, wantedListLibrary)
        }
    }
}

#Preview {
    NavigationStack {
        WantedListView()
            .navigationTitle("Wanted Lists")
    }
}
