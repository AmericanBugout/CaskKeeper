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
                .font(.customRegular(size: 18))
            Spacer()
            Group {
                if isEnabled {
                    Text("Yes")
                } else {
                    Text("No")
                }
            }
            .font(.customLight(size: 18))
        }
    }
}

#Preview {
    WhiskeyDetailRowViewToggle(title: "Opened", isEnabled: true)
}
