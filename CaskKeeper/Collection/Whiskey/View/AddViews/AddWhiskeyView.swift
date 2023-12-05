//
//  AddWhiskeyView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/21/23.
//

import SwiftUI
import UIKit
import Observation
import Combine

struct AddWhiskeyView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @Environment(\.dismiss) var dismiss
    
    @State private var label = ""
    @State private var bottle = ""
    @State private var style: Style = .bourbon
    @State private var purchaseDate: Date = .now
    @State private var proof = ""
    @State private var age = ""
    @State private var price = ""
    @State private var origin: Origin = .us
    @State private var isCameraShowing = false
    @State private var isPhotoLibraryShowing = false
    @State private var image: UIImage?
    
    private enum Field {
        case label
        case bottle
        case proof
        case age
        case price
    }
    
    @FocusState private var focusedField: Field?
    
    var nonOptionalImageBinding: Binding<UIImage> {
        Binding<UIImage>(
            get: { self.image ?? UIImage() },
            set: { self.image = $0 }
        )
    }
    
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
                    TextField("Label", text: $label)
                        .focused($focusedField, equals: .label)
                    
                    TextField("Bottle", text: $bottle)
                        .focused($focusedField, equals: .bottle)
                    
                    Picker("Style", selection: $style) {
                        ForEach(Style.allCases, id: \.self) { style in
                            Text(style.rawValue)
                        }
                    }
                    DatePicker("Purchased Date", selection: $purchaseDate, in: ...Date(), displayedComponents: .date)
                } header: {
                    Text("Whiskey Details")
                        .font(.customLight(size: 18))
                    Section {
                        TextField("Proof", text: $proof)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .proof)
                            .onChange(of: proof) { oldValue, newValue in
                                handleProofInput(newValue: newValue)
                            }
                        
                        TextField("Age", text: $age)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .age)
                            .onChange(of: age) { oldValue, newValue in
                                handleAgeInput(newValue: newValue)
                            }
                        
                        
                        TextField("Price", text: $price)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .price)
                            .onReceive(Just(price)) { newValue in
                                handlePriceInput(newValue: newValue)
                            }
                            .foregroundColor((price.isEmpty || price == "$" || price == "$0") ? .aluminum : .primary)
                        Picker("Origin", selection: $origin) {
                            ForEach(Origin.allCases, id: \.self) { origin in
                                Text(origin.rawValue)
                            }
                        }
                        
                    } header: {
                        Text("Additional Info")
                            .font(.customLight(size: 18))
                    }
                    
                    Section {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowBackground(Color.clear)
                        }
                    } header: {
                        HStack {
                            Text("Add Image")
                                .font(.customLight(size: 18))
                            Spacer()
                            Button(action: {
                                isCameraShowing = true
                            }, label: {
                                Image(systemName: "camera")
                            })
                            
                            Button(action: {
                                isPhotoLibraryShowing = true
                            }, label: {
                                Image(systemName: "photo.fill")
                            })
                        }
                    }
                    .sheet(isPresented: $isCameraShowing) {
                        ZStack {
                            ImagePickerRepresentable(selectedImage: nonOptionalImageBinding)
                                .ignoresSafeArea()
                        }
                    }
                    .sheet(isPresented: $isPhotoLibraryShowing) {
                        ZStack {
                            PHPickerRepresentable(selectedImage: nonOptionalImageBinding)
                                .ignoresSafeArea()
                        }
                    }
                }
                .font(.customRegular(size: 18))
                .navigationTitle("Add Bottle")
            }
            .toolbar{
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil // This clears the focus state
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation(Animation.easeInOut) {
                            guard let doubleProof = Double(proof) else { return }
                            let doubleAge = age.isEmpty ? nil : Double(age)
                            let submissionPrice = Double(price.trimmingCharacters(in: CharacterSet(charactersIn: "$"))) ?? 0.0
                            
                            whiskeyLibrary.addWhiskey(whiskey: Whiskey(label: label, bottle: bottle, purchasedDate: purchaseDate, image: image, proof: doubleProof, bottleState: .sealed, style: style, origin: origin, age: doubleAge, price: submissionPrice))
                            dismiss()
                        }
                    }
                    .disabled(label.isEmpty || bottle.isEmpty || proof.isEmpty)
                    .font(.customBold(size: 20))
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.customSemiBold(size: 20))
                }
            }
            .onDisappear {
                whiskeyLibrary.sortCollection()
            }
        }
        
    }
    
    func handleProofInput(newValue: String) {
        if newValue.isEmpty {
            return
        }
        
        let isDecimal = newValue.range(of: "^[0-9]{0,3}(\\.\\d{0,1})?$", options: .regularExpression) != nil
        
        if !isDecimal {
            proof = String(newValue.dropLast())
        }
    }
    
    func handleAgeInput(newValue: String) {
        if newValue.isEmpty {
            age = ""
            return
        }
        
        let isDecimal = newValue.range(of: "^[0-9]{0,3}(\\.\\d{0,1})?$", options: .regularExpression) != nil
        
        if let ageValue = Double(newValue), isDecimal && (0...100).contains(ageValue) {
            age = newValue
        } else {
            age = String(newValue.dropLast())
        }
    }
    
    func handlePriceInput(newValue: String) {
        if newValue.isEmpty {
            price = ""
        } else if newValue.first == "$" {
            let numericPart = String(newValue.dropFirst())
            
            let currencyRegex = "^[0-9]+(\\.\\d{0,2})?$"
            if let _ = Double(numericPart), numericPart.range(of: currencyRegex, options: .regularExpression) != nil {
                price = newValue
            } else {
                if !numericPart.isEmpty {
                    price = "$" + numericPart.dropLast()
                }
            }
        } else {
            let wholeNumberRegex = "^[0-9]+$"
            if newValue.range(of: wholeNumberRegex, options: .regularExpression) != nil {
                price = "$" + newValue
            } else {
                price = price.isEmpty ? "" : price
            }
        }
    }
}



#Preview {
    AddWhiskeyView()
}
