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
    
    var body: some View {
        List {
            Section {
                if whiskeyLibrary.collection.isEmpty {
                    EmptyView()
                } else {
                    ForEach(whiskeyLibrary.collection) { whiskey in
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
                    Text("Whiskey Collection (\(whiskeyLibrary.collectionCount))")
                        .font(.customLight(size: 18))
                }
            }
        }
        .onAppear {
            whiskeyLibrary.sortCollection()
        }
        .specialNavBar()
        .listStyle(.plain)
        .listRowSpacing(10)
        .sheet(isPresented: $isSheetViewShowing) {
            AddWhiskeyView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        isSheetViewShowing = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                
            }
            
            ToolbarItem(placement: .cancellationAction) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Sealed:")
                            .font(.customLight(size: 18))
                        Text("\(whiskeyLibrary.sealedCount)")
                            .font(.customBold(size: 18))
                            .foregroundStyle(Color.aluminum)
                            .bold()
                        Text("Opened:")
                            .font(.customLight(size: 18))
                            .foregroundStyle(Color.regularGreen)
                        Text("\(whiskeyLibrary.openedCount)")
                            .font(.customBold(size: 18))
                            .bold()
                        Text("Finished:")
                            .foregroundStyle(Color.accentColor)
                            .font(.customLight(size: 18))
                        Text("\(whiskeyLibrary.finishedCount)")
                            .font(.customBold(size: 18))
                            .bold()
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}

struct SpecialNavBar: ViewModifier {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "AsapCondensed-Bold", size: 42)!]
    }
    
    func body(content: Content) -> some View {
        content
    }
    
}

