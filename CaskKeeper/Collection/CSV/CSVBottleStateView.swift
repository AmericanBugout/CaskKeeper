//
//  CSVBottleStateView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/15/23.
//

import SwiftUI

struct CSVBottleStateView: View {
    var body: some View {
        HStack {
            Text("bottleState")
                .frame(width: 100, alignment: .leading)
                .foregroundStyle(Color.accentColor)
                .font(.customRegular(size: 16))

            Text("Sealed,    Open,    Finished")
            
            Spacer()
        }
        .font(.customLight(size: 16))
    }
}

#Preview {
    CSVBottleStateView()
}
