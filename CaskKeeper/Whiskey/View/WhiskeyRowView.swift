//
//  WhiskeyRowView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI

struct WhiskeyRowView: View {
    
    let whiskey: Whiskey
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Group {
                if whiskey.image == nil {
                    Image("noimageuploaded")// Default shape
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(.gray))
                } else {
                    if let image = whiskey.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text(whiskey.label)
                    .font(.custom("AsapCondensed-Semibold", size: 20, relativeTo: .body))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .font(.headline)
                Text(whiskey.bottle)
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Gauge(value: whiskey.avgScore, in: 0...100) {
                Text(String(format: "%.1f", whiskey.avgScore))
            }
            .frame(width: 75)
        }
    }
}

#Preview {
    WhiskeyRowView(whiskey: WhiskeyLibrary(isForTesting: true).collection.first!)
}
