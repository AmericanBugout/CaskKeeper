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

struct WhiskeyDetailRowAgeView: View {
    let title: String
    let detail: Double
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            Spacer()
            // Concatenate the formatted age string with the appropriate term "Year" or "Years"
            Text("\(formattedAgeString(from: detail)) \(detail == 1 ? "Year" : "Years")")
                .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
        }
    }
    
    func formattedAgeString(from age: Double) -> String {
        // Format the age to remove trailing ".0" for whole numbers
        let formattedString = age.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", age) : String(format: "%.1f", age)
        return formattedString
    }
}

struct WhiskeyDetailRowProofView: View {
    let title: String
    let detail: Double
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            Spacer()
            Text(String(format: "%.1f", detail))
                .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
        }
    }

}

#Preview {
    WhiskeyDetailRowView(title: "Label", detail: "Pikesville")
}
