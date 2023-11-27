//
//  HuntListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/26/23.
//

import SwiftUI

struct HuntListView: View {
    @State private var huntList: [String] = ["Fish", "Catfish"]
    
    var body: some View {
        List(huntList.indices, id: \.self) { index in
            HStack {
                Text("\(index + 1).")
                Text(huntList[index])
            }
            
        }
        .listStyle(.plain)
    }
}

#Preview {
    HuntListView()
}
