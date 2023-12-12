//
//  StatisticsPage.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/12/23.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.whiskeyLibrary) var whiskeyLibrary
    
    /* Price of collection
        Most Expensive
        Cheapest Bottle
        Longest Open
        ave proof
        ave age
        Label most owned
        most tastes
        highest score
        
     */
    
    var body: some View {
        List {
            Section {
                AverageProofRowView(proof: whiskeyLibrary.avgProof)
                AverageAgeRowView(age: whiskeyLibrary.avgAge)
                if let mostExpensive = whiskeyLibrary.mostExpensiveWhiskey {
                    MostExpensiveRowView(label: mostExpensive.label, price: mostExpensive.price ?? 0)
                }
                if let leastExpensive = whiskeyLibrary.leastExpensiveWhiskey {
                    LeastExpensiveRowView(label: leastExpensive.label, price: leastExpensive.price ?? 0)
                }
            } header: {
                Text("Statistics")
                    .font(.customLight(size: 18))
            }

        }
    }
  
}

#Preview {
    StatisticsView()
}

