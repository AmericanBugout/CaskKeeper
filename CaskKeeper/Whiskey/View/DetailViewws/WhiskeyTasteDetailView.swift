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
                        .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))
                        .font(.headline)
                        .foregroundStyle(.gray)
                    Text(taste.customNotes ?? "No Notes Entered")
                        .foregroundStyle(Color.accentColor)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 100, alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("Notes")
                        .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))
                        .foregroundStyle(.gray)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVStack(alignment: .leading) {
                        ForEach(taste.notes) { flavor in
                            FlavorCell(flavor: flavor, isSelected: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("Score")
                        .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))
                        .foregroundStyle(.gray)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                    ZStack {
                        Circle()
                            .strokeBorder(Color.accentColor, lineWidth: 4)
                            .background(Circle().fill(Color.lead))
                            .frame(width: 200, height: 200)
                            .shadow(color: .gray, radius: 10)
                        Text("\(taste.score)")
                            .font(.custom("AsapCondensed-Bold", size: 68))
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
                    .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))

            }
        }
        .navigationTitle("Tasting Notes")
        
    }
}

#Preview {
    WhiskeyTasteDetailView(taste: Whiskey.Taste(date: Date(), customNotes: "eqwjeqwjhidhiwhdcisbcbdwhbchdbchbdhschsbhjbcjhsbdjhbcjshdbchbsdjhbchjksbadchbsdhjbchbsd", notes: [Flavor(name: "Cherry"), Flavor(name: "Grape")], score: 87))
}
