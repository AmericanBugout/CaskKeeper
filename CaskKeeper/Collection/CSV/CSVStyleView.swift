//
//  CSVStyleView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/15/23.
//

import SwiftUI

struct CSVStyleView: View {
    private let style = ["Rye", "Bourbon", "Irish", "Scotch", "Japanese", "Tennessee", "Canadian"]
    
    var body: some View {
        HStack {
            Text("style")
                .font(.customRegular(size: 16))
                .frame(width: 100, alignment: .leading)
                .foregroundStyle(Color.accentColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(style, id: \.self) { style in
                        HStack {
                            Text("\(style),")
                        }
                    }
                }
            }
        }
        .font(.customLight(size: 16))
    }
}

#Preview {
    CSVStyleView()
}
