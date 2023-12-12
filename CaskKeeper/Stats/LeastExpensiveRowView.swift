//
//  LeastExpensiveRowView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/12/23.
//

import SwiftUI

struct LeastExpensiveRowView: View {
    let label: String
    let price: Double
    
    var body: some View {
        HStack {
            Text("Least Expensive")
                .font(.customRegular(size: 20))
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(label)
                Text("$\(price, format: .number.precision(.fractionLength(0...2)))")
            }
            .font(.customLight(size: 20))
        }
    }
}

#Preview {
    LeastExpensiveRowView(label: "Rittenhouse", price: 29.99)
}
