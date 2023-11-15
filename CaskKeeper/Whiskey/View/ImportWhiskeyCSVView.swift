//
//  ImportWhiskeyCSVView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/14/23.
//

import SwiftUI

struct ImportWhiskeyCSVView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @State private var isCSVImportShowing: Bool = false
    
    private let fields = ["label", "bottle", "style", "bottleState", "origin", "finish", "proof", "purchasedDate", "dateOpened", "locationPurchased"]
    
    private let headers: [String: String] = [
        "COLUMN 1": "label",
        "COLUMN 2": "bottle",
        "COLUMN 3": "style",
        "COLUMN 4": "bottleState",
        "COLUMN 5": "origin",
        "COLUMN 6": "finish",
        "COLUMN 7": "proof",
        "COLUMN 8": "purchasedDate",
        "COLUMN 9": "dateOpened",
        "COLUMN 10": "locationPurhased",
    ]
    
    var sortedHeaders: [(String, String)] {
        headers.sorted { a, b in
            guard let aNumber = Int(a.key.components(separatedBy: " ").last!),
                  let bNumber = Int(b.key.components(separatedBy: " ").last!) else {
                return false
            }
            return aNumber < bNumber
        }
    }
        
    
    var body: some View {
        List {
            Section {
                Text("CaskKeeper allows you to import a whiskey list from a csv file. Below are the following instructions for successfully loading a collection.")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
            } header: {
                Text("Instructions")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            }
            .listRowSeparator(.hidden)
            
            Section {
                Text("Below are the required header values. They must be in the exact order and match the exact casing. Of course, the data should be comma seperated.")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(Array(sortedHeaders), id: \.0) { key, value in
                        HStack {
                            Text(key)
                                .foregroundStyle(Color.accentColor)
                                .frame(maxWidth: .infinity)
                            Text(headers[key] ?? "")
                                .frame(maxWidth: .infinity)

                        }
                        .padding(.horizontal)
                    }
                }
                
                .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
            } header: {
                Text("Required Header Row Values")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))

            }
            .listRowSeparator(.hidden)


        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    isCSVImportShowing = true
                } label: {
                    Image(systemName: "square.and.arrow.down.fill")
                }

            }
        }
        .sheet(isPresented: $isCSVImportShowing) {
            DocumentPicker { whiskeys in
                withAnimation(Animation.easeInOut(duration: 1)) {
                    for index in whiskeys.indices {
                        if whiskeys[index].bottleState == .opened {
                            whiskeys[index].firstOpen = false
                            whiskeys[index].opened = true
                        }
                    }
                    whiskeyLibrary.collection.append(contentsOf: whiskeys)
                }
            }
        }
        .listStyle(.plain)
        .listSectionSpacing(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Import Whiskeys")
    }
}

#Preview {
    ImportWhiskeyCSVView()
}
