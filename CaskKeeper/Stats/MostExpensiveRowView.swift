//
//  MostExpensiveRowView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/12/23.
//

import SwiftUI

struct MostExpensiveRowView: View {
    let label: String
    let bottle: String
    let price: Double
    
    var body: some View {
        HStack {
            Text("Most Expensive")
                .font(.customRegular(size: 20))
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(label)
                Text(bottle)
                Text("$\(price, format: .number.precision(.fractionLength(0...2)))")
                    .foregroundStyle(.accent)
            }
            .font(.customLight(size: 20))
        }
    }
}

#Preview {
    MostExpensiveRowView(label: "Single Rickhouse", bottle: "Nelson Camp F", price: 299.99)
}
