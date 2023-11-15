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
    @State private var score: Int = 50
    @State private var isAlertShowing: Bool = false
    @State private var isBottleFinished: Bool = false

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
                        .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
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
                            .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
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
                
                Section {
                    VStack {
                        
                        ZStack {
                            Circle()
                                .strokeBorder(Color.accentColor, lineWidth: 4)
                                .background(Circle().fill(Color.lead))
                                .frame(width: 125, height: 125)
                                .shadow(color: .gray, radius: 10)
                            Text("\(score)")
                                .font(.custom("AsapCondensed-Bold", size: 68))
                                .foregroundColor(.accentColor)
                        }
                        .frame(width: 125, height: 125)
                        
                        Slider(value: Binding(get: {
                            Double(score)
                        }, set: {
                            score = Int($0.rounded())
                        }),
                        in: 1...100)
                        .padding(.top, 10)
                    }
                    .background(content: {
                        
                    })
                    .padding(.horizontal)
                } header: {
                    Text("Taste Rating")
                        .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(flavorCatalog.selectedFlavors.isEmpty ? .top : .bottom)

                }
                
                Section {
                    HStack(alignment: .center) {
                        Text("Is Bottle Finished?")
                            .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))

                        Spacer()
                        Button {
                            withAnimation(Animation.smooth) {
                                isBottleFinished.toggle()
                            }
                        } label: {
                            Image(systemName: isBottleFinished ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(isBottleFinished ? Color.green : .gray)
                        }
                    }
                } header: {
                   
                }
                .padding(.top)
                .padding(.horizontal)

            }
                        
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation(Animation.smooth) {
                            var taste = Whiskey.Taste(date: Date(), customNotes: textEditor, score: score)
                            taste.notes.append(contentsOf: flavorCatalog.selectedFlavors)
                            whiskeyLibrary.addWhiskeyTasting(for: whiskey, tasting: taste)
                            if isBottleFinished {
                                whiskeyLibrary.updateWhiskeyToFinished(whiskey: whiskey)
                            }
                            dismiss()
                        }
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
