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
        Longest Open
        Label most owned
     */
    
    var body: some View {
        List {
            Section {
                AverageProofRowView(proof: whiskeyLibrary.avgProof)
                AverageAgeRowView(age: whiskeyLibrary.avgAge)
                if let mostExpensive = whiskeyLibrary.mostExpensiveWhiskey {
                    MostExpensiveRowView(label: mostExpensive.label, bottle: mostExpensive.bottle, price: mostExpensive.price ?? 0)
                }
                if let leastExpensive = whiskeyLibrary.leastExpensiveWhiskey {
                    LeastExpensiveRowView(label: leastExpensive.label, bottle: leastExpensive.bottle, price: leastExpensive.price ?? 0)
                }
                if let rated = whiskeyLibrary.highestRated {
                    HighestRatedRowView(label: rated.label, bottle: rated.bottle, score: rated.avgScore)
                }
                if let mostTastes = whiskeyLibrary.mostTastes {
                    MostTastesRowView(label: mostTastes.label, bottle: mostTastes.bottle, tasteCount: mostTastes.tastingNotes.count)
                }
                if let longestOpen = whiskeyLibrary.longestOpen {
                    LongestOpenedView(label: longestOpen.label, bottle: longestOpen.bottle, date: longestOpen.dateOpened ?? Date())
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

