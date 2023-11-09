//
//  FlavorModel.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/4/23.
//

import SwiftUI

class FlavorCatalog: ObservableObject {
    
    @Published var searchString: String = ""
    @Published var selectedFlavors: Set<Flavor> = Set<Flavor>()
    @Published var flavors: [Flavor] = []
    
    var filteredFlavors: [Flavor] {
        if searchString.isEmpty {
            return flavors.sorted(by: { $0.name < $1.name })
        } else {
            return flavors.filter { $0.name.localizedCaseInsensitiveContains(searchString) }
        }
    }
    
    init() {
       flavors = loadFlavors(from: "flavors")
    }
    
    func loadFlavors(from filename: String) -> [Flavor] {
        guard let dataAsset = NSDataAsset(name: filename) else {
            fatalError("Failed to load asset \(filename)")
        }

        do {
            let flavorNames = try JSONDecoder().decode([String].self, from: dataAsset.data)
            return flavorNames.map { Flavor(name: $0) }
        } catch {
            fatalError("Failed to decode \(filename) from asset catalog: \(error)")
        }
    }
    
    func toggleFlavor(_ flavor: Flavor) {
           if selectedFlavors.contains(flavor) {
               selectedFlavors.remove(flavor)
           } else {
               selectedFlavors.insert(flavor)
           }
           // Reset the search string if needed
           searchString = ""
       }
       
    
}
