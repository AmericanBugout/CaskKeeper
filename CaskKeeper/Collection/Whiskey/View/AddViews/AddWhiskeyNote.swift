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
    @State private var textEditor = ""
    @State private var score = 50
    @State private var isAlertShowing = false
    @State private var isBottleFinished = false

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
                        .font(.customLight(size: 18))
                        .scrollContentBackground(.hidden)
                        .frame(height: 150)
                        .padding(.horizontal)
                        .cornerRadius(5) // Optional: if you want rounded corners
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.lead, lineWidth: 1) 
                                .padding(.horizontal, 10)// Optional: if you want a border around the TextEditor
                        )
                    
                } header: {
                    Text("Custom Notes")
                        .font(.customRegular(size: 18))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding(.leading)
                        .foregroundColor(.aluminum)
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
                            .font(.customRegular(size: 18))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            .foregroundColor(.aluminum)
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
                                .shadow(color: .aluminum, radius: 10)
                            Text("\(score)")
                                .font(.customBold(size: 68))
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
                    .padding(.horizontal)
                } header: {
                    Text("Taste Rating")
                        .font(.customRegular(size: 18))
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .foregroundColor(.aluminum)
                        .padding(.horizontal)
                        .padding(flavorCatalog.selectedFlavors.isEmpty ? .top : .bottom)

                }
                
                Section {
                    HStack(alignment: .center) {
                        Text("Is Bottle Finished?")
                            .font(.customLight(size: 18))

                        Spacer()
                        Button {
                            withAnimation(Animation.smooth) {
                                isBottleFinished.toggle()
                            }
                        } label: {
                            Image(systemName: isBottleFinished ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(isBottleFinished ? Color.regularGreen : .aluminum)
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
                    .font(.customBold(size: 20))
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.customSemiBold(size: 20))
                }
            }
            .navigationTitle("Tasting Note")
        }
    }
}

#Preview {
    AddWhiskeyNote(whiskey: WhiskeyLibrary(isForTesting: true).collection.first!)
}
