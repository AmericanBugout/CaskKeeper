//
//  WhiskeyRowView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI

struct WhiskeyRowView: View {
    @AppStorage("showImages") var showImages = true
    @State private var imageLoader = ImageLoader()
    let whiskey: Whiskey
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Group {
                if showImages {
                    Group {
                        if let image = imageLoader.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 70, height: 70)
                        } else {
                            Image("noimageuploaded") // Placeholder or default image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 70, height: 70)
                                .background(Circle().fill(Color.aluminum))
                        }
                    }
                    .onAppear {
                        imageLoader.loadImage(from: whiskey.imageData, with: whiskey.id)
                    }
                }
                
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4){
                    Text(whiskey.label)
                        .font(.customRegular(size: 16))
                        .lineLimit(1)
                        .font(.headline)
                        .foregroundStyle(Color.aluminum)
                        .frame(width: 125, alignment: .leading)
                    
                    Text(whiskey.bottle)
                        .font(.customLight(size: 14))
                        .lineLimit(1)
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 125, alignment: .leading)
                }
                
                Group {
                    switch whiskey.bottleState {
                    case .sealed:
                        Text("Sealed".uppercased())
                            .foregroundStyle(Color.lead)
                    case .opened:
                        Text("Open".uppercased())
                            .foregroundStyle(Color.regularGreen)
                    case .finished:
                        Text("Finished".uppercased())
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .font(.customBold(size: 18))
                .lineLimit(1)
                
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
