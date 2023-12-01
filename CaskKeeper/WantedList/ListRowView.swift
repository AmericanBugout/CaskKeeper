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
                        .foregroundStyle(Color.accentColor)
                        .padding(10)
                        .background(.ultraThickMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.aluminum, lineWidth: 2)
                        )
                }
                
                VStack {
                    Text(name)
                        .font(.customBold(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Group {
                            Text("Total")
                                .font(.customRegular(size: 18))
                            Text("\(total)")
                                .font(.customSemiBold(size: 18))
                        }
                        .foregroundStyle(Color.green)
                        
                        Group {
                            Text("Found")
                                .font(.customRegular(size: 18))
                            Text("\(found)")
                                .font(.customSemiBold(size: 18))
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
