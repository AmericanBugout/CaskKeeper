//
//  HighestRatedRowView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/12/23.
//

import SwiftUI

struct HighestRatedRowView: View {
    let label: String
    let bottle: String
    let score: Double
    
    var body: some View {
        HStack {
            Text("Highest Rated")
                .font(.customRegular(size: 20))
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(label)
                Text(bottle)
                HStack {
                    Text(score, format: .number.precision(.fractionLength(0...2)))
                    Text("/   100")
                }
                .foregroundStyle(.accent)
            }
            .font(.customLight(size: 20))
        }
    }
}

#Preview {
    HighestRatedRowView(label: "Single Rickhouse", bottle: "Nelson Camp F", score: 98)
}
