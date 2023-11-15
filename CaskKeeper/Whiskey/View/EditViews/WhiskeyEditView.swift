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
    @State private var finishWhiskeyConfirmation: Bool = false
    @State private var whiskeyProofString = ""
    @State private var whiskeyAgeString = ""
    
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
                WhiskeyEditTextField(text: $whiskey.finish, placeholder: "Finish")
                WhiskeyEditTextField(text: $whiskeyProofString, placeholder: "Proof")
                    .onChange(of: whiskeyProofString) { oldValue, newValue in
                        handleProofInput(newValue: newValue)
                    }
                
                DatePicker("Purchased Date", selection: $whiskey.purchasedDate, displayedComponents: .date)
                
                WhiskeyEditTextField(text: $whiskeyAgeString, placeholder: "Aged")
                    .onChange(of: whiskeyAgeString) { oldValue, newValue in
                        handleAgeInput(newValue: newValue)
                    }
                
                Picker("Origin", selection: $whiskey.origin) {
                    ForEach(Origin.allCases, id: \.self) { origin in
                        Text(origin.rawValue)
                    }
                }
                
                Toggle("Opened", isOn: $whiskey.opened)
                    .onChange(of: whiskey.opened) { oldValue, newValue in
                        if oldValue == true {
                            finishWhiskeyConfirmation.toggle()
                            whiskey.bottleState = .finished
                        }
                        
                        if oldValue == false && whiskey.firstOpen {
                            whiskeyLibrary.updateOpenedDate(whiskey: whiskey)
                            whiskey.bottleState = .opened
                        }
                    }
                Toggle("Buy Again", isOn: $whiskey.wouldBuyAgain)
                WhiskeyEditTextField(text: $whiskey.locationPurchased, placeholder: "Location Purchased")
            
            }
            .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            .navigationTitle(whiskey.label)
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.custom("AsapCondensed-Semibold", size: 20, relativeTo: .body))
                    .confirmationDialog("Finish Whiskey?", isPresented: $finishWhiskeyConfirmation) {
                        Button(role: .destructive) {
                            whiskeyLibrary.updateWhiskeyToFinished(whiskey: whiskey)
                            whiskeyLibrary.updateWhiskey(updatedWhiskey: whiskey)
                            dismiss()
                        } label: {
                            Text("Finish Whiskey")
                        }
                    } message: {
                        Text("This will finish the whiskey and you be unable to make changes. Are you sure?")
                    }
                }
            }
            .onAppear(perform: {
                whiskeyProofString = String(whiskey.proof)
                whiskeyAgeString = formatNumberString(whiskey.age)
            })
        }
    }
    
    func formatNumberString(_ number: Double) -> String {
        return number.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", number) : String(number)
    }
    
    func handleProofInput(newValue: String) {
        // If the newValue is empty (e.g., the user deleted all input), then it's okay.
            if newValue.isEmpty {
                whiskeyProofString = newValue
                whiskey.proof = 0 // Assign a default value or handle this scenario appropriately
                return
            }

            // Check if the newValue is a valid decimal.
            let isDecimal = newValue.range(of: "^[0-9]{0,3}(\\.\\d{0,1})?$", options: .regularExpression) != nil

            // If not a valid decimal or exceeds limits, revert to the previous value.
            if !isDecimal {
                whiskeyProofString = String(newValue.dropLast())
            } else {
                // Here we assume that `whiskey.proof` is a Double.
                // Use your number formatter to convert the valid string to a Double.
                if let number = numberFormatter.number(from: newValue) {
                    whiskey.proof = number.doubleValue
                    whiskeyProofString = newValue
                }
            }
    }
    
    func handleAgeInput(newValue: String) {
        if newValue.isEmpty {
                whiskeyAgeString = newValue
                whiskey.age = 0 // Assign a default value or handle this scenario appropriately
                return
            }

            // Check if the newValue is a valid decimal.
            let isDecimal = newValue.range(of: "^[0-9]{0,3}(\\.\\d{0,1})?$", options: .regularExpression) != nil

            // If newValue is a valid decimal, proceed to check the range
            if isDecimal {
                if let ageValue = Double(newValue), (0...100).contains(ageValue) {
                    // It's a valid decimal and within the range, so update the age
                    whiskey.age = ageValue
                    whiskeyAgeString = newValue
                } else if let ageValue = Double(newValue) {
                    // If it's a valid decimal but not within the range, revert to the previous value.
                    // This will limit the value to be within the range of 0 to 100.
                    let limitedValue = min(max(ageValue, 0), 100)
                    whiskey.age = limitedValue
                    whiskeyAgeString = String(limitedValue)
                } else {
                    // If the conversion to Double fails, revert to the last known good value.
                    whiskeyAgeString = String(newValue.dropLast())
                }
            } else {
                // If not a valid decimal, revert to the previous valid value.
                whiskeyAgeString = String(newValue.dropLast())
            }
    }

}

#Preview {
    WhiskeyEditView(whiskey: .constant(WhiskeyLibrary(isForTesting: true).collection.first!))
}
