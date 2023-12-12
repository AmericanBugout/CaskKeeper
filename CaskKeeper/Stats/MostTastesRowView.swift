//
//  MostTastesRowView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/12/23.
//

import SwiftUI

struct MostTastesRowView: View {
    let label: String
    let bottle: String
    let tasteCount: Int
    
    var body: some View {
        HStack {
            Text("Most Tastes")
                .font(.customRegular(size: 20))
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(label)
                Text(bottle)
                Text("\(tasteCount)")
                    .foregroundStyle(.accent)
            }
            .font(.customLight(size: 20))
        }
    }
}

#Preview {
    MostTastesRowView(label: "Single Rickhouse", bottle: "Camp F", tasteCount: 3)
}
