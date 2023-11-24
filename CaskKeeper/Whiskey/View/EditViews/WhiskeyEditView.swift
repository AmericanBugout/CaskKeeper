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
    @State private var priceString = ""
    @State private var dateOpened: Date = .now
    @State private var purchasedDate: Date = .now
    @State private var isAgeDefined = false

    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
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
                    
                    WhiskeyEditTextField(text: $whiskeyAgeString, placeholder: "Aged")
                        .onChange(of: whiskeyAgeString) { oldValue, newValue in
                            handleAgeInput(newValue: newValue)
                        }
                    
                    Picker("Origin", selection: $whiskey.origin) {
                        ForEach(Origin.allCases, id: \.self) { origin in
                            Text(origin.rawValue)
                        }
                    }
                    
                    
                } header: {
                    Text("Bottle Details")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                }
                
                Section {
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
                    if whiskey.bottleState == .opened {
                        DatePicker("Opened Date", selection: $dateOpened, displayedComponents: .date)
                            .onChange(of: dateOpened) { old, new in
                                whiskey.dateOpened = new
                            }
                    }
                    
                    Toggle("Buy Again", isOn: $whiskey.wouldBuyAgain)
                    
                } header: {
                    Text("Additional Bottle Details")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                }
                
                Section {
                    WhiskeyEditTextField(text: $whiskey.locationPurchased, placeholder: "Location Purchased")
                    
                    DatePicker("Purchased Date", selection: $purchasedDate, displayedComponents: .date)
                        .onChange(of: purchasedDate) { old, new in
                            whiskey.purchasedDate = new
                        }
                    
                    WhiskeyEditTextField(text: $priceString, placeholder: "Price")
                        .foregroundColor((priceString.isEmpty || priceString == "$" || priceString == "$0" || priceString == "0.0") ? .aluminum : .white)
                        .onChange(of: priceString) { oldalue, newValue in
                            handlePriceInput(newValue: newValue)
                        }
                } header: {
                    Text("Purchase Details")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                }
                
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
                            whiskeyLibrary.updatedToGifted(whiskey: whiskey)
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
                if whiskey.age != 0 {
                    whiskeyAgeString = formatNumberString(whiskey.age)
                }
                setupPriceString()
                
                if let dateOpened = whiskey.dateOpened {
                    self.dateOpened = dateOpened
                }
                
                if let purchasedDate = whiskey.purchasedDate {
                    self.purchasedDate = purchasedDate
                }
                print(whiskey.wasGifted)
            })
       }
    }
    
    func setupPriceString() {
        // Check if whiskey.price is 0.0 and set priceString accordingly
        if let whiskeyPrice = whiskey.price, whiskeyPrice != 0.0 {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.currencySymbol = "$" // If you want to force US dollar symbol
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2

                if let formattedPriceString = formatter.string(from: NSNumber(value: whiskeyPrice)) {
                    priceString = formattedPriceString
                }
            } else {
                // If the whiskey price is 0.0, we'll set the priceString to an empty string
                priceString = ""
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
    
    func handlePriceInput(newValue: String) {
        // If the input is empty or just a dollar sign, set it to an empty string and whiskey.price to nil
        if newValue.isEmpty || newValue == "$" {
            priceString = ""
            whiskey.price = nil
        } else if newValue.first == "$" {
            // Drop the dollar sign to check the numeric part
            let numericPart = String(newValue.dropFirst())
            
            // Check if the numeric part is a valid currency format (whole number or up to two decimal places)
            let currencyRegex = "^[0-9]+(\\.\\d{0,2})?$"
            if let numericValue = Double(numericPart), numericPart.range(of: currencyRegex, options: .regularExpression) != nil {
                // If it's a valid currency format, update the price
                priceString = newValue
                whiskey.price = numericValue // Assuming whiskey is a class instance that's accessible here and price can be non-nil
            } else {
                // If not a valid currency format, revert to the previous valid value
                // This will prevent invalid characters or formats from being entered
                if !numericPart.isEmpty {
                    priceString = "$" + numericPart.dropLast()
                }
            }
        } else {
            // If the new value does not start with a dollar sign, check if it's a valid number
            let wholeNumberRegex = "^[0-9]+$"
            if let numericValue = Double(newValue), newValue.range(of: wholeNumberRegex, options: .regularExpression) != nil {
                // Directly use the whole number as the price
                priceString = "$" + newValue
                whiskey.price = numericValue // Assuming whiskey is a class instance that's accessible here and price can be non-nil
            } else {
                // If it's not a valid whole number, reset to the previous valid price or default to an empty string
                priceString = priceString.isEmpty ? "" : priceString
            }
        }
        
    }



}

#Preview {
    WhiskeyEditView(whiskey: .constant(WhiskeyLibrary(isForTesting: true).collection.first!))
}
