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
    WhiskeyTasteDetailView(taste: Whiskey.Taste(date: Date(), customNotes: "eqwjeqwjhidhiwhdcisbcbdwhbchdbchbdhschsbhjbcjhsbdjhbcjshdbchbsdjhbchjksbadchbsdhjbchbsd", notes: [Flavor(name: "Cherry"), Flavor(name: "Grape")]))
}
