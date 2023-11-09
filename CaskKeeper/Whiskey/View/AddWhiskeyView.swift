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
    
    @State private var label: String = ""
    @State private var bottle: String = ""
    @State private var style: Style = .bourbon
    @State private var purchaseDate: Date = .now
    @State private var proof: String = ""
    @State private var origin: Origin = .us
    @State private var age: Age = .six
    @State private var isCameraShowing: Bool = false
    @State private var isPhotoLibraryShowing: Bool = false
    @State private var image: UIImage?
        
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
            Form {
                Section {
                    TextField("Label", text: $label)
                    TextField("Bottle", text: $bottle)
                    Picker("Style", selection: $style) {
                        ForEach(Style.allCases, id: \.self) { style in
                            Text(style.rawValue)
                        }
                    }
                    DatePicker("Purchased Date", selection: $purchaseDate, displayedComponents: .date)
                } header: {
                    Text("Whiskey Details")
                }
                
                Section {
                    TextField("Proof", text: $proof)
                        .onChange(of: proof) { oldValue, newValue in
                            handleProofInput(newValue: newValue)
                        }
                    Picker("Age", selection: $age) {
                        ForEach(Age.allCases, id: \.self) { age in
                            Text(age.rawValue)
                        }
                    }
                    
                    Picker("Origin", selection: $origin) {
                        ForEach(Origin.allCases, id: \.self) { origin in
                            Text(origin.rawValue)
                        }
                    }
                    
                } header: {
                    Text("Addiitonal Info")
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
                .popover(isPresented: $isCameraShowing) {
                    ZStack {
                        ImagePickerRepresentable(selectedImage: nonOptionalImageBinding)
                            .ignoresSafeArea()
                    }
                }
                .popover(isPresented: $isPhotoLibraryShowing) {
                    ZStack {
                        PHPickerRepresentable(selectedImage: nonOptionalImageBinding)
                            .ignoresSafeArea()
                    }
                }
            }
            .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            .toolbar{
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation(Animation.easeInOut) {
                            guard let doubleProof = Double(proof) else { return }
                            whiskeyLibrary.addWhiskey(whiskey: Whiskey(label: label, bottle: bottle, purchasedDate: purchaseDate, image: image, proof: doubleProof, style: style, origin: origin, age: age))
                            dismiss()
                        }
                    }
                    .disabled(label.isEmpty || bottle.isEmpty || proof.isEmpty)
                    .font(.custom("AsapCondensed-Bold", size: 20, relativeTo: .body))

                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.custom("AsapCondensed-SemiBold", size: 20, relativeTo: .body))

                }
            }
            .navigationTitle("Add Bottle")
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
            proof = String(newValue.dropLast())
        }
    }
}

#Preview {
    AddWhiskeyView()
}
