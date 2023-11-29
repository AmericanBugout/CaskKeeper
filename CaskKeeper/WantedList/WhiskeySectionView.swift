//
//  WhiskeySectionView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/29/23.
//

import SwiftUI

struct WhiskeySectionView: View {
    let title: String
    @Binding var items: [WhiskeyItem]
    var action: ((WhiskeyItem) -> Void)
    
    var body: some View {
        VStack {
            Text(title)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.customSemiBold(size: 18))
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        VStack {
                            HStack {
                                if title == "Wanted" {
                                    Text("\(index + 1). ")
                                        .font(.customSemiBold(size: 18))
                                }
                                Text(items[index].name)
                                Spacer()
                                Button {
                                    withAnimation(Animation.smooth(duration: 1)) {
                                        switch items[index].state {
                                        case .looking:
                                            items[index].state = .found
                                        case .found:
                                            items[index].state = .looking
                                        }
                                        action(items[index])
                                    }
                                } label: {
                                    Image(systemName: items[index].state == .looking ? "circle" : "checkmark.circle.fill")
                                            .imageScale(.medium)
                                            .foregroundStyle(items[index].state == .looking ? Color.aluminum : Color.regularGreen)
                                }
                            }
                            .padding(.horizontal)
                            .font(.customRegular(size: 18))
                            
                            if let endDate = items[index].endSearchDate {
                                VStack {
                                    Text("Found on ")
                                    + Text(endDate, style: .date)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .font(.customLight(size: 12))
                                .foregroundStyle(Color.accentColor)
                                .opacity(0.7)
                            }
                        }
                        .padding(.top, 5)
                    }
                }
            }
            .frame(height: 200)
        }
    }
}

#Preview {
    WhiskeySectionView(title: "Found", items: .constant([
        WhiskeyItem(name: "Mid Night's Winter Dram"),
        WhiskeyItem(name: "Mid Night's Winter Dram"),
        WhiskeyItem(name: "Mid Night's Winter Dram"),
        WhiskeyItem(name: "Mid Night's Winter Dram"),
        WhiskeyItem(name: "Mid Night's Winter Dram"),
        WhiskeyItem(name: "Mid Night's Winter Dram"),
        WhiskeyItem(name: "Mid Night's Winter Dram"),
        WhiskeyItem(name: "Mid Night's Winter Dram"),
        WhiskeyItem(name: "Mid Night's Winter Dram")])) { item in
        
    }
}

