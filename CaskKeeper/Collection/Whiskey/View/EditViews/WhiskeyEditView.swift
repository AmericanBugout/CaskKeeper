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
    @State private var finishWhiskeyConfirmation = false
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
                        .font(.customLight(size: 18))
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
                        DatePicker("Opened Date", selection: $dateOpened, in: ...Date(), displayedComponents: .date)
                            .onChange(of: dateOpened) { old, new in
                                withAnimation(Animation.smooth(duration: 1)) {
                                    whiskey.dateOpened = new
                                }
                            }
                    }
                    
                    Toggle("Buy Again", isOn: $whiskey.wouldBuyAgain)
                    
                } header: {
                    Text("Additional Bottle Details")
                        .font(.customLight(size: 18))
                }
                
                Section {
                    WhiskeyEditTextField(text: $whiskey.locationPurchased, placeholder: "Location Purchased")
                    
                    DatePicker("Purchased Date", selection: $purchasedDate, in: ...Date(), displayedComponents: .date)
                        .onChange(of: purchasedDate) { old, new in
                            withAnimation(Animation.smooth(duration: 1)) {
                                whiskey.purchasedDate = new
                            }
                        }
                    
                    WhiskeyEditTextField(text: $priceString, placeholder: "Price")
                        .foregroundColor((priceString.isEmpty || priceString == "$" || priceString == "$0" || priceString == "0.0") ? .aluminum : .primary)
                        .onChange(of: priceString) { oldalue, newValue in
                            withAnimation(Animation.smooth(duration: 1)) {
                                handlePriceInput(newValue: newValue)
                            }
                        }
                } header: {
                    Text("Purchase Details")
                        .font(.customLight(size: 18))
                }
                
            }
            .font(.customRegular(size: 18))
            .navigationTitle(whiskey.label)
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.customSemiBold(size: 20))
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
        // Remove any characters that are not numbers, a period, or a dollar sign at the beginning
        let filteredString = newValue.filter { "0123456789.".contains($0) }
        
        // Check if the newValue starts with a dollar sign and remove it for the numeric check
        let numericString = newValue.first == "$" ? String(newValue.dropFirst()) : filteredString
        
        // Regex for valid currency format (optional dollar sign, numbers, optional period, up to two decimal places)
        let currencyRegex = "^(\\d*)(\\.\\d{0,2})?$"
        
        if numericString.range(of: currencyRegex, options: .regularExpression) != nil {
            // It's a valid currency format, update the priceString and whiskey.price
            priceString = "$" + numericString
            whiskey.price = Double(numericString)
        } else {
            // If it's not a valid currency format, don't update the priceString or whiskey.price
            // This will prevent invalid characters or formats from being entered
        }
    }

}

#Preview {
    WhiskeyEditView(whiskey: .constant(WhiskeyLibrary(isForTesting: true).collection.first!))
}
