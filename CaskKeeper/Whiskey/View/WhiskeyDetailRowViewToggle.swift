//
//  WhiskeyDetailRowViewToggle.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/7/23.
//

import SwiftUI

struct WhiskeyDetailRowViewToggle: View {
    
    let title: String
    let isEnabled: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            Spacer()
            Group {
                if isEnabled {
                    Text("Yes")
                        .foregroundColor(.green)
                } else {
                    Text("No")
                        .foregroundColor(.red)
                }
            }
            .font(.custom("AsapCondensed-Bold", size: 18, relativeTo: .body))
        }
    }
}

#Preview {
    WhiskeyDetailRowViewToggle(title: "Opened", isEnabled: true)
}
