//
//  HuntListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI

struct WantedListView: View {
    @State private var wantedListLibrary = WantedListLibrary(isForTesting: true)
    @State private var addWantedViewIsShowing = false
    
    var groupedLists: [String: [WantedList]] {
        Dictionary(grouping: wantedListLibrary.wantedLists, by: { $0.style })
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(groupedLists.keys.sorted(), id: \.self) { style in
                    Section(header: Text(style).font(.customRegular(size: 18))) {
                        ForEach(groupedLists[style] ?? [], id: \.self) { list in
                            NavigationLink(value: list) {
                                VStack(alignment: .leading) {
                                    Text(list.description ?? "")
                                        .font(.customLight(size: 18))
                                }
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .navigationDestination(for: WantedList.self, destination: { list in
                Text(list.name)
            })
            .navigationDestination(for: WantedList.self, destination: { list in
                Text(list.name)
            })
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
                AddWantedListView()
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
