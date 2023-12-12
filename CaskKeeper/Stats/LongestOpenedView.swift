//
//  LongestOpenedVIew.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/12/23.
//

import SwiftUI

struct LongestOpenedView: View {
    let label: String
    let bottle: String
    let date: Date
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy" // Example of a shorter date format
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack {
            Text("Longest Open")
                .font(.customRegular(size: 20))
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(label)
                Text(bottle)
                Text("Opened - \(formattedDate)")
                    .foregroundStyle(.accent)
            }
            .font(.customLight(size: 20))
        }
    }
}

#Preview {
    LongestOpenedView(label: "Russels", bottle: "SlappStick", date: Date())
}
