//
//  AverageProofRowView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/12/23.
//

import SwiftUI

struct AverageProofRowView: View {
    let proof: Double
    
    var body: some View {
        HStack {
            Text("Avg Proof")
                .font(.customRegular(size: 20))
            Spacer()
            Text(proof, format: .number.precision(.fractionLength(0...1)))
                .font(.customLight(size: 20))
        }
    }
}

#Preview {
    AverageProofRowView(proof: 90.44554)
}
