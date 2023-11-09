//
//  WhiskeyEditView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/30/23.
//

import SwiftUI
import Combine

struct WhiskeyEditView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @Environment(\.dismiss) var dismiss
    @Binding var whiskey: Whiskey
    @State private var whiskeyProofString = ""
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List {
                WhiskeyEditTextField(text: $whiskey.label, placeholder: "Label")
                WhiskeyEditTextField(text: $whiskey.bottle, placeholder: "Bottle")
                
                Picker("Style", selection: $whiskey.style) {
                    ForEach(Style.allCases, id: \.self) { style in
                        Text(style.rawValue)
                    }
                }
                
                WhiskeyEditTextField(text: $whiskey.batch, placeholder: "Batch #")
                WhiskeyEditTextField(text: $whiskeyProofString, placeholder: "Proof")
                    .onChange(of: whiskeyProofString, perform: { value in
                        handleProofInput(newValue: value)
                    })
                
                DatePicker("Purchased Date", selection: $whiskey.purchasedDate, displayedComponents: .date)
                
                Picker("Age", selection: $whiskey.age) {
                    ForEach(Age.allCases, id: \.self) { age in
                        Text(age.rawValue)
                    }
                }
                
                Picker("Origin", selection: $whiskey.origin) {
                    ForEach(Origin.allCases, id: \.self) { origin in
                        Text(origin.rawValue)
                    }
                }
                
                Toggle("Opened", isOn: $whiskey.opened)
                Toggle("Open for 6 months", isOn: $whiskey.isOpenedFor6Months)
                Toggle("Buy Again", isOn: $whiskey.wouldBuyAgain)
                WhiskeyEditTextField(text: $whiskey.locationPurchased, placeholder: "Location Purchased")
            }
            .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            .navigationTitle(whiskey.label)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        whiskeyLibrary.updateWhiskey(updatedWhiskey: whiskey)
                        dismiss()
                    }
                    .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))

                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.custom("AsapCondensed-Semibold", size: 20, relativeTo: .body))
                }
            }
            .onAppear(perform: {
                whiskeyProofString = String(whiskey.proof)
            })
        }
    }
    
    func handleProofInput(newValue: String) {
        // If the newValue is empty (e.g., the user deleted all input), then it's okay.
        if newValue.isEmpty {
            return
        }

        // Check if the newValue is a valid decimal.
        let isDecimal = newValue.range(of: "^[0-9]{0,3}(\\.\\d{0,1})?$", options: .regularExpression) != nil

        // If not a valid decimal or exceeds limits, revert to the previous value.
        if !isDecimal {
            whiskeyProofString = String(newValue.dropLast())
        }
    }

}

#Preview {
    WhiskeyEditView(whiskey: .constant(WhiskeyLibrary(isForTesting: true).collection.first!))
}
