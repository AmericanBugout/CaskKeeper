//
//  FlavorModel.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 11/4/23.
//

import SwiftUI
import Observation

@Observable
class FlavorCatalog {
    
    var searchString = ""
    var selectedFlavors: Set<Flavor> = Set<Flavor>()
    var flavors: [Flavor] = []
    
    var filteredFlavors: [Flavor] {
        if searchString.isEmpty {
            return flavors.sorted(by: { $0.name < $1.name })
        } else {
            return flavors.filter { $0.name.localizedCaseInsensitiveContains(searchString) }
        }
    }
    
    init() {
       flavors = loadFlavors(from: "flavors", extension: "json")
    }
    
    func loadFlavors(from resourceName: String, extension ext: String) -> [Flavor] {
            guard let url = Bundle.main.url(forResource: resourceName, withExtension: ext) else {
                fatalError("Failed to load \(resourceName).\(ext) from bundle")
            }

            do {
                let data = try Data(contentsOf: url)
                let flavorNames = try JSONDecoder().decode([String].self, from: data)
                return flavorNames.map { Flavor(name: $0) }
            } catch {
                fatalError("Failed to decode \(resourceName).\(ext) from bundle: \(error)")
            }
        }
    
    func toggleFlavor(_ flavor: Flavor) {
           if selectedFlavors.contains(flavor) {
               selectedFlavors.remove(flavor)
           } else {
               selectedFlavors.insert(flavor)
           }
           searchString = ""
       }
}
