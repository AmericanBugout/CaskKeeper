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
                .font(.customRegular(size: 16))
            
            Text(value)
            
            Spacer()
        }
        .font(.customLight(size: 16))
    }
}

#Preview {
    CSVInfoValueRow(header: "label", value: "\"String\"")
}
