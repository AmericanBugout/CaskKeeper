//
//  ContentView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @State private var isSheetViewShowing: Bool = false
    @State private var importCSVView: Bool = false
    @State private var trials: [SmallWhiskey] = []
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if whiskeyLibrary.collection.isEmpty {
                        EmptyView()
                    } else {
                        ForEach(whiskeyLibrary.collection.sorted(by: {$0.label < $1.label}), id: \.self) { whiskey in
                            ZStack {
                                NavigationLink {
                                    WhiskeyDetailView(whiskey: whiskey)
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                WhiskeyRowView(whiskey: whiskey)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: whiskeyLibrary.deleteAtIndex)
                        .listRowSeparator(.hidden, edges: .all)
                        .listRowInsets(.init(top: 5, leading: 5, bottom: 5, trailing: 10))
                    }
                } header: {
                    if whiskeyLibrary.collection.isEmpty {
                        EmptyView()
                    } else {
                        Text("Whiskey Collection")
                            .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                    }
                }
            }
            .listStyle(.plain)
            .listRowSpacing(10)
            .navigationTitle("Collection")
            .sheet(isPresented: $isSheetViewShowing) {
                AddWhiskeyView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            importCSVView = true
                        } label: {
                            Text("Import Whiskeys")
                            Image(systemName: "square.and.arrow.down.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    } label: {
                        Image(systemName: "gear")
                    }
                    .sheet(isPresented: $importCSVView) {
                        DocumentPicker { whiskeys in
                            withAnimation(Animation.smooth(duration: 1)) {
                                for index in whiskeys.indices {
                                    if whiskeys[index].bottleState == .opened {
                                        whiskeys[index].firstOpen = false
                                    }
                                }
                                whiskeyLibrary.collection.append(contentsOf: whiskeys)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        isSheetViewShowing = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    HStack {
                        Text("Total:")
                            .font(.custom("AsapCondensed-Light", size: 20, relativeTo: .body))
                        Text("\(whiskeyLibrary.collectionCount)")
                            .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))
                            .bold()
                        
                        Button("Delete Whiskey") {
                            whiskeyLibrary.collection.removeAll()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

