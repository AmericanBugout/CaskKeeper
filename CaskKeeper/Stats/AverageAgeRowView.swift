//
//  AverageAgeRowView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/12/23.
//

import SwiftUI

struct AverageAgeRowView: View {
    let age: Double
    
    var ageText: String {
        let formattedAge = age.formatted(.number.precision(.fractionLength(0...1)))
        return age == 1 ? "\(formattedAge) Year" : "\(formattedAge) Years"
    }
    
    var body: some View {
        HStack {
            Text("Avg Age")
                .font(.customRegular(size: 20))
            Spacer()
            Text(ageText)
                .font(.customLight(size: 20))
                .foregroundStyle(.accent)
        }
    }
}

#Preview {
    AverageAgeRowView(age: 6.6)
}
