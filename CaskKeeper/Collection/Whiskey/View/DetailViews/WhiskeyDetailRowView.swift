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
                .font(.customRegular(size: 18))
            Spacer()
            Text(detail)
                .font(.customLight(size: 18))
        }
    }
}

struct WhiskeyDetailRowAgeView: View {
    let title: String
    let detail: Double
    
    var body: some View {
        HStack {
            Text(title)
                .font(.customRegular(size: 18))
                .foregroundStyle(detail == 0 ? Color.secondary : Color.primary)
            
            Spacer()
            
            Text(detail == 0 ? "" : "\(formattedAgeString(from: detail)) \(detail == 1 ? "Year" : "Years")")
                .font(.customLight(size: 18))
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
        detail == 0 ? .secondary : .primary // `.primary` is typically the default text color
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.customRegular(size: 18))
                .foregroundStyle(detail == 0 ? Color.secondary : Color.primary)
            
            Spacer()
            
            Text(formattedPrice)
                .font(.customLight(size: 18))
                .foregroundColor(detail == 0 ? .aluminum : .primary)
        }
    }
}

struct WhiskeyDetailRowProofView: View {
    let title: String
    let detail: Double
    
    var body: some View {
        HStack {
            Text(title)
                .font(.customRegular(size: 18))
            Spacer()
            Text(String(format: "%.1f", detail))
                .font(.customLight(size: 18))
        }
    }
    
}

#Preview {
    WhiskeyDetailRowView(title: "Label", detail: "Pikesville")
}
