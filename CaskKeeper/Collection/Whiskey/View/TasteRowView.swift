//
//  TasteRowView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/7/23.
//

import SwiftUI

struct TasteRowView: View {
    let taste: Whiskey.Taste
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(taste.date, style: .date)
                    .font(.customLight(size: 16))
                Spacer() 
                ZStack {
                    Circle()
                        .strokeBorder(Color.accentColor, lineWidth: 4)
                        .background(Circle().fill(Color.lead))
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.lead, radius: 5)
                    Text("\(taste.score)")
                        .font(.customBold(size: 18))
                        .foregroundColor(.accentColor)
                }
                .frame(width: 50, height: 50)
                .padding(.top)
                .padding(.trailing, 7)
            }
            .padding(.bottom)
           
            Text(taste.customNotes ?? "No notes entered.")
                .font(.customLight(size: 18))
                .foregroundStyle(.aluminum)
                .multilineTextAlignment(.leading)
                    
            LazyVGrid(columns: columns) {
                ForEach(taste.notes, id: \.self) { note in
                    HStack {
                        Text(note.name)
                            .font(.customLight(size: 16))
                            .lineLimit(1)
                            .foregroundStyle(Color.accentColor)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                            .background(Color.lead)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 5)
            .padding(.horizontal, 1)
        }
        .padding(.top, 4)
    }
}

#Preview {
    TasteRowView(taste: Whiskey.Taste(date: Date(), customNotes: "Lots of caramel. A smooth drinker. Hot.", notes: [Flavor(name: "Oak"), Flavor(name: "Vanilla"), Flavor(name: "Burnt Toast")], score: 88))
}
