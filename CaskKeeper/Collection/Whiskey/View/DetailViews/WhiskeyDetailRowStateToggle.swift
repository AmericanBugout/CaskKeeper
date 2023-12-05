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
                .font(.customRegular(size: 18))
            Spacer()
            Group {
                switch state {
                case .sealed:
                    Text("Sealed")
                        .foregroundColor(.aluminum)
                        .font(.customLight(size: 18))
                case .opened:
                    Text("Opened")
                        .foregroundColor(.green)
                        .font(.customLight(size: 18))
                case .finished:
                    Text("Finished")
                        .foregroundColor(.accentColor)
                        .font(.customLight(size: 18))
                }
            }
            .font(.customBold(size: 18))
        }
    }
}

#Preview {
    WhiskeyDetailRowStateToggle(title: "Bottle State", state: .finished)
}
