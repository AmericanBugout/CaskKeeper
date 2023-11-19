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
                .font(.custom("AsapCondensed-Regular", size: 16, relativeTo: .body))

            Text("Sealed,    Open,    Finished")
            Spacer()
            
        }
        .font(.custom("AsapCondensed-Light", size: 16, relativeTo: .body))
    }
}

#Preview {
    CSVBottleStateView()
}
