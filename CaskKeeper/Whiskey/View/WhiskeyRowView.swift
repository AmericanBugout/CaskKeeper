//
//  WhiskeyRowView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI

struct WhiskeyRowView: View {
    @AppStorage("showImages") var showImages: Bool = true
    let whiskey: Whiskey
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Group {
                if showImages {
                    if whiskey.image == nil {
                        Image("noimageuploaded")// Default shape
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 70, height: 70)
                            .background(Circle().fill(.aluminum))
                    } else {
                        if let image = whiskey.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                        }
                    }
                }
                
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4){
                    Text(whiskey.label)
                        .font(.custom("AsapCondensed-Semibold", size: 20, relativeTo: .body))
                        .lineLimit(1)
                        .font(.headline)
                        .foregroundStyle(Color.aluminum)
                        .frame(width: 125, alignment: .leading)

                    Text(whiskey.bottle)
                        .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                        .lineLimit(1)
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 125, alignment: .leading)
                }
                
                Group {
                    switch whiskey.bottleState {
                    case .sealed:
                        Text("Sealed".uppercased())
                            .font(.custom("AsapCondensed-Bold", size: 18, relativeTo: .body))
                            .foregroundStyle(Color.lead)
                    case .opened:
                        Text("Open".uppercased())
                            .font(.custom("AsapCondensed-Bold", size: 18, relativeTo: .body))
                            .foregroundStyle(Color.systemGreen)
                    case .finished:
                        Text("Finished".uppercased())
                            .font(.custom("AsapCondensed-Bold", size: 18, relativeTo: .body))
                            .foregroundStyle(Color.accentColor)
                    }
                }
                                
            }
            .padding(showImages ? .init(top: 0, leading: 0, bottom: 0, trailing: 0) : .init(top: 0, leading: 10, bottom: 0, trailing: 0))

            
            Spacer()
            
            if whiskey.avgScore == 0.0 {
                Text("")
            } else {
                Gauge(value: whiskey.avgScore, in: 0...100) {
                    Text(String(format: "%.1f", whiskey.avgScore))
                }
                .gaugeStyle(ScoreGaugeStyle())
                .frame(width: 75)
            }
        }
    }
}

#Preview {
    WhiskeyRowView(whiskey: WhiskeyLibrary(isForTesting: true).collection.first!)
}
