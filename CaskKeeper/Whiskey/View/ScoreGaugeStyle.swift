//
//  ScoreGaugeView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/11/23.
//

import SwiftUI

struct ScoreGaugeStyle: GaugeStyle {
    
    var gradient = LinearGradient(colors: [.gray, .accentColor], startPoint: .trailing, endPoint: .leading)
  //  var score: Double
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.black)
            
            Circle()
                .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: 0.75 * configuration.value)
                .stroke(gradient, lineWidth: 8)
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .miter, dash: [1.0, 1.0], dashPhase: 0))
                .rotationEffect(.degrees(135))
            
            VStack {
                configuration.label
                    .font(.custom("AsapCondensed-Bold", size: 18, relativeTo: .body))
                    .foregroundColor(.gray)
                Text("Avg Score")
                    .font(.custom("AsapCondensed-Regular", size: 10, relativeTo: .body))


                    
            }
        }
        .frame(width: 60, height: 60)
    }
    
    
}

#Preview {
    Gauge(value: 10.0, in: 0...100, label: {
        Text("100.0")
    })
    .gaugeStyle(ScoreGaugeStyle())
}
