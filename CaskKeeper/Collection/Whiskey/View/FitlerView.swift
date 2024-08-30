//
//  FitlerView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/11/23.
//

import SwiftUI

enum FilterState: String, CaseIterable {
    case all = "All"
    case sealed = "Sealed"
    case opened = "Opened"
    case finished = "Finished"
    
    var description: String {
        switch self {
        case .all:
            return "All"
        case .sealed:
            return "Sealed"
        case .opened:
            return "Opened"
        case .finished:
            return "Finished"
        }
    }
    
    var colorCode: Color {
        switch self {
        case .all:
            Color.primary
        case .sealed:
            Color.aluminum
        case .opened:
            Color.regularGreen
        case .finished:
            Color.accentColor
        }
    }
}

struct FilterView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    
    let options: [FilterState] = [.all, .opened, .sealed, .finished]
    
    @Binding var selection: Int
    
    @State private var styleSelecttion = 0
    @State private var selectedStyle: Style = .all
    
    var onSelection: (FilterState) -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(options.indices, id: \.self) { index in
                    VStack {
                        Text(options[index].rawValue)
                            .font(.customLight(size: 14))
                            .opacity(selection == index ? 1 : 0.3)
                            .padding(.horizontal, 2)
                            .frame(width: 65)
                        returnCollectionCount(state: options[index], style: selectedStyle)
                    }
                    .foregroundStyle(options[index].colorCode)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Clip shape with rounded corners
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selection == index ? options[index].colorCode : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        withAnimation(Animation.snappy(duration: 1)) {
                            selection = index
                            onSelection(options[index])
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            StyleFilterView(selection: $styleSelecttion) { style in
                whiskeyLibrary.styleFilter = style
                self.selectedStyle = style
            }
            .padding(.top, 5)
        }
        
    }
    
    private func returnCollectionCount(state: FilterState, style: Style) -> some View {
        
        switch state {
        case .all:
            return Text("\(whiskeyLibrary.collectionCountWithStyleFilter(style: style))")
                .font(.customRegular(size: 18))
        case .sealed:
            return Text("\(whiskeyLibrary.sealedCount(style: style))")
                .font(.customRegular(size: 18))
        case .opened:
            return Text("\(whiskeyLibrary.openedCount(style: style))")
                .font(.customRegular(size: 18))
        case .finished:
            return Text("\(whiskeyLibrary.finishedCount(style: style))")    
                .font(.customRegular(size: 18))
        }
    }
}

#Preview {
    FilterView(selection: .constant(2)) { state in
        
    }
}
