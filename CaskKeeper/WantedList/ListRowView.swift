//
//  ListRowView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/1/23.
//

import SwiftUI

struct ListRowView: View {
    let name: String
    let total: Int
    let found: Int
    let wanted: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                VStack {
                    Text("\(wanted)")
                        .font(.customBold(size: 30))
                        .minimumScaleFactor(0.5) // Adjusts text size to fit
                        .frame(width: 35, height: 35) // Fixed frame size
                        .foregroundStyle(Color.regularGreen)
                        .padding(5)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.lead, lineWidth: 2)
                        )
                }
                
                VStack {
                    Text(name)
                        .font(.customBold(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Group {
                            Text("Total")
                                .font(.customRegular(size: 20))
                            Text("\(total)")
                                .font(.customSemiBold(size: 20))
                        }
                        .foregroundStyle(Color.accentColor)
                        
                        Group {
                            Text("Found")
                                .font(.customRegular(size: 20))
                            Text("\(found)")
                                .font(.customSemiBold(size: 20))
                        }
                        .foregroundStyle(Color.aluminum)
                        Spacer()
                    }
                }
                .padding(.leading, 10)
                Spacer()
            }
        }
    }
}

#Preview {
    ListRowView(name: "Most Famous Ryes", total: 10, found: 5, wanted: 5)
}
