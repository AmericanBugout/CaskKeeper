//
//  StyleFilterView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 8/30/24.
//

import SwiftUI

struct StyleFilterView: View {
        
    let options: [Style] = [.all, .bourbon, .rye, .tennessee, .scotch, .irish, .canadian, .japanese]
    
    @Binding var selection: Int
    
    var onSelection: (Style) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(options.indices, id: \.self) { index in
                    VStack {
                        Text(options[index].rawValue)
                            .font(.customLight(size: 16))
                            .opacity(selection == index ? 1 : 0.3)
                            .padding(.horizontal, 11)
                            .foregroundStyle(selection == index ? .accent : .primary)
                    }
                    .onTapGesture {
                        withAnimation(Animation.snappy(duration: 1)) {
                            selection = index
                            print(options[index])
                            onSelection(options[index])
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    StyleFilterView(selection: .constant(1)) { style in
        
    }
}
