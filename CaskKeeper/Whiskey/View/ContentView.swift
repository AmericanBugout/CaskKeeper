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
            .specialNavBar()
            .listStyle(.plain)
            .listRowSpacing(10)
            .navigationTitle("Collection")
            .sheet(isPresented: $isSheetViewShowing) {
                AddWhiskeyView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "menucard")
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
                            withAnimation(Animation.easeIn(duration: 1)) {
                                whiskeyLibrary.collection.removeAll()
                            }
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

struct SpecialNavBar: ViewModifier {

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "AsapCondensed-Bold", size: 42)!]
    }

    func body(content: Content) -> some View {
        content
    }

}

extension View {

    func specialNavBar() -> some View {
        self.modifier(SpecialNavBar())
    }

}
