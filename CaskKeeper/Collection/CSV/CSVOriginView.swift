//
//  CSVOriginVieew.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/15/23.
//

import SwiftUI

struct CSVOriginView: View {
    
    private let origin = ["United States", "Scotland", "Ireland", "Canada", "Japan", "India", "Taiwan", "England"]

    var body: some View {
        HStack {
            Text("origin")
                .frame(width: 100, alignment: .leading)
                .font(.customRegular(size: 16))
                .foregroundStyle(Color.accentColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(origin, id: \.self) { origin in
                        HStack {
                            Text("\(origin),")
                        }
                    }
                }
            }
        }
        .font(.customLight(size: 16))
    }
}

#Preview {
    CSVOriginView()
}
