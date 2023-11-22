//
//  WhiskeyDetailRowStateToggle.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/12/23.
//

import SwiftUI

struct WhiskeyDetailRowStateToggle: View {
    
    let title: String
    let state: BottleState
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            Spacer()
            Group {
                switch state {
                case .sealed:
                    Text("Sealed")
                        .foregroundColor(.gray)
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                case .opened:
                    Text("Opened")
                        .foregroundColor(.green)
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                case .finished:
                    Text("Finished")
                        .foregroundColor(.accentColor)
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                }
            }
            .font(.custom("AsapCondensed-Bold", size: 18, relativeTo: .body))        }
    }
}

#Preview {
    WhiskeyDetailRowStateToggle(title: "Bottle State", state: .finished)
}
