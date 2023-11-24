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
                .foregroundStyle(detail == 0 ? Color.secondary : Color.primary)
            
            Spacer()
            
            Text(detail == 0 ? "" : "\(formattedAgeString(from: detail)) \(detail == 1 ? "Year" : "Years")")
                .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
        }
    }
    
    func formattedAgeString(from age: Double) -> String {
        let formattedString = age.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", age) : String(format: "%.1f", age)
        return formattedString
    }
}

struct WhiskeyDetailPriceView: View {
    let title: String
    let detail: Double
    
    var formattedPrice: String {
        guard detail != 0 else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // You can set this to specific locale if needed
        return formatter.string(from: NSNumber(value: detail)) ?? ""
    }
    
    var titleColor: Color {
        detail == 0 ? .aluminum : .primary // `.primary` is typically the default text color
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                .foregroundColor(titleColor)
            
            Spacer()
            
            Text(formattedPrice)
                .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                .foregroundColor(detail == 0 ? .aluminum : .white)
        }
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
