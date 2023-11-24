//
//  CSVInfoValueRow.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/15/23.
//

import SwiftUI

struct CSVInfoValueRow: View {
    let header: String
    let value: String
    
    var body: some View {
        HStack {
            Text(header)
                .frame(width: 100, alignment: .leading)
                .foregroundStyle(Color.accentColor)
                .font(.custom("AsapCondensed-Regular", size: 16, relativeTo: .body))
            
            Text(value)
            
            Spacer()
        }
        .font(.custom("AsapCondensed-Light", size: 16, relativeTo: .body))
    }
}

#Preview {
    CSVInfoValueRow(header: "label", value: "\"String\"")
}
