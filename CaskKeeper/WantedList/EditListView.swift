//
//  EditListView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 12/1/23.
//

import SwiftUI

struct EditListView: View {
    @Binding var wantedList: WantedList
    
    var body: some View {
        List {
            Section {
                
            }header: {
                Text("Edit List")
            }
            Text(wantedList.name)
        }
        .navigationTitle("Edit Wanted List")
    }
}

#Preview {
    EditListView(wantedList: .constant(WantedList(name: "Hard to come by Ryes", style: "Rye", description: nil, whiskeys: [WhiskeyItem(name: "High West")])))
}
