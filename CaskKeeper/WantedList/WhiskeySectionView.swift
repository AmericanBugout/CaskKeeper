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
        List {
            ForEach(items.indices, id: \.self) { index in
                VStack {
                    HStack(alignment: .top) {
                        if title == "Wanted" {
                            Text("\(index + 1). ")
                                .font(.customSemiBold(size: 18))
                        }
                        Text(items[index].name)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        Spacer()
                        Button {
                            withAnimation(.easeIn(duration: 1)) {
                                
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
            .onMove(perform: move)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
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

