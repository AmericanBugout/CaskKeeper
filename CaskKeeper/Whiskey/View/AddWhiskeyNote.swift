//
//  SwiftUIView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/4/23.
//

import SwiftUI

struct AddWhiskeyNote: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @Environment(\.dismiss) var dismiss
    
    @State private var flavorCatalog = FlavorCatalog()
    @State private var textEditor: String = ""

    let whiskey: Whiskey
        
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Section {
                    TextEditor(text: $textEditor)
                        .font(.body)
                        .scrollContentBackground(.hidden)
                        .frame(height: 150)
                        .padding(.horizontal)
                        .cornerRadius(5) // Optional: if you want rounded corners
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.lead, lineWidth: 1) // Optional: if you want a border around the TextEditor
                        )
                    
                } header: {
                    Text("Custom Notes")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding(.leading)
                        .foregroundColor(.gray)
                }
                
                Section {
                    if !flavorCatalog.selectedFlavors.isEmpty {
                        VStack(alignment: .leading) {
                            LazyVGrid(columns: columns, spacing: 2) {
                                ForEach(Array(flavorCatalog.selectedFlavors), id: \.self) { flavor in
                                    FlavorCell(flavor: flavor, isSelected: true)
                                }
                            }
                            .padding([.leading, .trailing, .bottom])
                        }
                        .cornerRadius(10)
                    }
                    
                } header: {
                    HStack {
                        Text("Selected Flavors")
                            .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            .foregroundColor(.gray)
                        Spacer()
                        NavigationLink {
                            FlavorSelectionView(searchString: $flavorCatalog.searchString)
                                .environment(\.flavorCatalog, flavorCatalog)
                        } label: {
                            Image(systemName: "swatchpalette.fill")
                        }
                    }
                    .padding(.horizontal)
                    
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var taste = Whiskey.Taste(date: Date(), customNotes: textEditor)
                        taste.notes.append(contentsOf: flavorCatalog.selectedFlavors)
                        whiskeyLibrary.addWhiskeyTasting(for: whiskey, tasting: taste)
                        dismiss()
                    }
                    .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))

                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.custom("AsapCondensed-SemiBold", size: 20, relativeTo: .body))

                }
                
            }
            .navigationTitle("Tasting Note")
        }
    }
}

#Preview {
    AddWhiskeyNote(whiskey: WhiskeyLibrary(isForTesting: true).collection.first!)
}
