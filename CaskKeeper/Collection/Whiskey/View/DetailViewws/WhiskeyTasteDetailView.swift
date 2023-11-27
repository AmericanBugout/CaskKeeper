//
//  WhiskeyTasteDetailView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/5/23.
//

import SwiftUI

struct WhiskeyTasteDetailView: View {
    
    let taste: Whiskey.Taste
    
    var body: some View {
        VStack {
            Section {
                VStack(alignment: .leading) {
                    Text("Custom Notes")
                        .font(.customBold(size: 20))
                        .font(.headline)
                        .foregroundStyle(.aluminum)
                    Text(taste.customNotes ?? "No Notes Entered")
                        .foregroundStyle(Color.accentColor)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 100, alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("Notes")
                        .font(.customBold(size: 20))
                        .foregroundStyle(.aluminum)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVStack(alignment: .leading) {
                        ForEach(taste.notes, id: \.self) { flavor in
                            FlavorCell(flavor: flavor, isSelected: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("Score")
                        .font(.customBold(size: 20))
                        .foregroundStyle(.aluminum)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                    ZStack {
                        Circle()
                            .strokeBorder(Color.accentColor, lineWidth: 4)
                            .background(Circle().fill(Color.lead))
                            .frame(width: 200, height: 200)
                            .shadow(color: .aluminum, radius: 10)
                        Text("\(taste.score)")
                            .font(.customBold(size: 68))
                            .foregroundColor(.accentColor)
                    }
                    .frame(width: 200, height: 200)
                    .padding(.top)
                }
               
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Text(taste.date, style: .date)
                    .foregroundStyle(Color.accentColor)
                    .font(.customBold(size: 20))

            }
        }
        .navigationTitle("Tasting Notes")
        
    }
}

#Preview {
    WhiskeyTasteDetailView(taste: Whiskey.Taste(date: Date(), customNotes: "Will never buy again.", notes: [Flavor(name: "Cherry"), Flavor(name: "Grape")], score: 87))
}
