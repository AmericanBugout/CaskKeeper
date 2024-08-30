//
//  ContentView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @State private var isSheetViewShowing = false
    @State private var importCSVView = false
    @State private var selection = 0
    @State private var styleSelecttion = 0
    
    var body: some View {
        VStack {
            List {
                FilterView(selection: $selection, onSelection: { state in
                    whiskeyLibrary.currentFilter = state
                })
                .listRowSeparator(.hidden)
                StyleFilterView(selection: $styleSelecttion) { style in
                    whiskeyLibrary.styleFilter = style
                }
                .listRowSeparator(.hidden)

                Section {
                    if whiskeyLibrary.collection.isEmpty {
                        ZStack {
                            Text("No whiskeys in your collection.")
                                .font(.customLight(size: 22))
                                .foregroundStyle(.aluminum)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        }
                        .frame(height: 500)
                        .listRowSeparator(.hidden)
                    } else {
                        ForEach(whiskeyLibrary.filteredWhiskeys) { whiskey in
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
                    Text("Whiskey Collection")
                        .font(.customLight(size: 18))
                }
            }
            .onAppear {
                whiskeyLibrary.sortCollection()
            }
            .specialNavBar()
            .listStyle(.plain)
            .listRowSpacing(10)
        }
        .sheet(isPresented: $isSheetViewShowing) {
            AddWhiskeyView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        isSheetViewShowing = true
                    } label: {
                        VStack {
                            Text("New")
                        }
                        .font(.customRegular(size: 16))
                    }
                }
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .specialNavBar()
            .navigationTitle("Collection")
    }
}

struct SpecialNavBar: ViewModifier {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "AsapCondensed-Bold", size: 42)!]
    }
    
    func body(content: Content) -> some View {
        content
    }
    
}

