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
            Text("style")
                .frame(width: 100, alignment: .leading)
                .font(.custom("AsapCondensed-Regular", size: 16, relativeTo: .body))
                .foregroundStyle(.accent)
            
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
        .font(.custom("AsapCondensed-Light", size: 16, relativeTo: .body))
    }
}

#Preview {
    CSVOriginView()
}
