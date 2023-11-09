//
//  WhiskeyDetailRowView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/31/23.
//

import SwiftUI

struct WhiskeyDetailRowView: View {
    let title: String
    let detail: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            Spacer()
            Text(detail)
                .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
        }
    }
}

#Preview {
    WhiskeyDetailRowView(title: "Label", detail: "Pikesville")
}
