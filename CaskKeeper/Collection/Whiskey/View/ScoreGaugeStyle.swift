//
//  ScoreGaugeView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/11/23.
//

import SwiftUI

struct ScoreGaugeStyle: GaugeStyle {
    @Environment(\.colorScheme) var colorScheme
    var gradient = LinearGradient(colors: [.white, .accentColor], startPoint: .trailing, endPoint: .leading)
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.clear)
            
            Circle()
                .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: 0.75 * configuration.value)
                .stroke(gradient, lineWidth: 8)
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(colorScheme == .light ? .white : .black, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .miter, dash: [1.0, 1.0], dashPhase: 0))
                .rotationEffect(.degrees(135))
            
            VStack {
                configuration.label
                    .font(.customBold(size: 18))
                    .foregroundColor(.aluminum)
                Text("Avg Score")
                    .font(.customRegular(size: 10))
            }
        }
        .frame(width: 60, height: 60)
    }
}

#Preview {
    Gauge(value: 88.0, in: 50...100, label: {
        Text("100.0")
    })
    .gaugeStyle(ScoreGaugeStyle())
}
