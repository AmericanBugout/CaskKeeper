//
//  NavigationStateView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/12/23.
//

import SwiftUI

struct NavigationStateView: View {
    let state: BottleState
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.ultraThinMaterial)
                .padding()
            switch state {
            case .sealed:
                Text("SEALED")
            case .opened:
                Text("OPENED")
            case .finished:
                Text("FINSISHED")
            }
        }
        .font(.custom("AsapCondensed-Bold", size: 18, relativeTo: .body))
        .foregroundStyle(state.color)

    }
}

#Preview {
    NavigationStateView(state: .finished)
}
