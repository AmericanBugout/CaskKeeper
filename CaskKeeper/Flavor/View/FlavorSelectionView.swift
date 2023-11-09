//
//  AddWhiskeyTasteView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/3/23.
//

import SwiftUI
import Observation

struct FlavorSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.flavorCatalog) private var flavorCatalog
    
    @Binding var searchString: String
        
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            if !flavorCatalog.selectedFlavors.isEmpty {
                VStack(alignment: .leading) {
                    Text("Selected Flavors")
                        .font(.headline)
                        .padding(.leading)
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(Array(flavorCatalog.selectedFlavors), id: \.self) { flavor in
                            FlavorCell(flavor: flavor, isSelected: true)
                                .onTapGesture {
                                    withAnimation(Animation.smooth(duration: 0.5)) {
                                        flavorCatalog.toggleFlavor(flavor)
                                    }
                                }
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                .cornerRadius(10)
            }
            
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(flavorCatalog.filteredFlavors, id: \.self) { flavor in
                    FlavorCell(flavor: flavor, isSelected: flavorCatalog.selectedFlavors.contains(flavor))
                        .onTapGesture {
                            withAnimation(Animation.smooth(duration: 0.5)) {
                                flavorCatalog.toggleFlavor(flavor)
                            }
                        }
                }
            }
            .padding()
        }
        .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search Flavor"))
        .navigationTitle("Add Flavor Notes")
        .toolbar {
            addButton
        }
    }
    
    var addButton: some View {
        Button(action: addFlavors) {
            Text("Add (\(flavorCatalog.selectedFlavors.count))")
                .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))
                .foregroundColor(flavorCatalog.selectedFlavors.isEmpty ? .gray : .green)
        }
        .disabled(flavorCatalog.selectedFlavors.isEmpty)
    }
    
    private func addFlavors() {
        dismiss()
    }
}

struct FlavorCell: View {
    let flavor: Flavor
    var isSelected: Bool
    
    var body: some View {
        Text(flavor.name)
            .font(.custom("AsapCondensed-SemiBold", size: 18, relativeTo: .body))
            .lineLimit(1)
            .foregroundStyle(isSelected ? Color.black : Color.accentColor)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.accentColor : Color.lead)
            .cornerRadius(8)
    }
}




//#Preview {
//    var flavors: Set<Flavor> = [Flavor(name: "Cherry")]
//    
//    FlavorSelectionView(selectedFlavors: Binding.constant(flavors))
//}
