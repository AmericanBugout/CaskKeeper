//
//  CSVImportView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/15/23.
//

import SwiftUI

struct CSVImportView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    
    @State private var isImportViewShowing: Bool = false
    @State private var whiskeysFromCSV: [Whiskey] = []
    @State private var importWasSuccess: Bool = false
    @State private var errorShowing: Bool = false
    @State private var error: String?
    @State private var retryCount: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    VStack {
                        if importWasSuccess {
                            Text("\(whiskeysFromCSV.count)")
                                .font(.custom("AsapCondensed-Bold", size: 72, relativeTo: .body))
                                .opacity(importWasSuccess ? 1 : 0)
                                .scaleEffect(importWasSuccess ? 1 : 0.9)
                                .rotationEffect(importWasSuccess ? Angle(degrees: 0) : Angle(degrees: -10))
                                .foregroundStyle(importWasSuccess ? .green : .aluminum)
                                .transition(AnyTransition(.slide))
                                .offset(y: importWasSuccess ? 0 : -500)
                            HStack {
                                Text("Imported Whiskeys".uppercased())
                                    .font(.custom("AsapCondensed-SemiBold", size: 24, relativeTo: .body))
                                    .foregroundStyle(.aluminum)
                                    .opacity(importWasSuccess ? 1 : 0)
                                Image(systemName: importWasSuccess ? "checkmark.circle.fill" : "circle")
                                    .opacity(importWasSuccess ? 1 : 0)
                                    .scaleEffect(importWasSuccess ? 1 : 0.9)
                                    .rotationEffect(importWasSuccess ? Angle(degrees: 0) : Angle(degrees: -10))
                                    .foregroundStyle(importWasSuccess ? .green : .aluminum)
                            }
                            .offset(x: importWasSuccess ? 0 : 10)
                        } else if error != nil {
                            VStack {
                                Text("Error")
                                    .font(.custom("AsapCondensed-SemiBold", size: 32, relativeTo: .body))
                                    .foregroundStyle(Color.red)
                                    
                            }
                            .offset(y: error != nil ? 0 : 1000)
                            .transition(AnyTransition(.slide))
                            
                            HStack {
                                Text("Imported Whiskeys".uppercased())
                                    .font(.custom("AsapCondensed-SemiBold", size: 24, relativeTo: .body))
                                    .foregroundStyle(Color.aluminum)
                                    
                                Image(systemName: "x.circle.fill")
                                    .foregroundStyle(Color.red)
                            }
                            .offset(x: error != nil ? 0 : -800)
                            .transition(AnyTransition(.slide))

                            
                            Text(error ?? "Something went wrong")
                                .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                                .padding(.top, 5)
                        }
                    }
                }
                .frame(height: 300)
                
                Button {
                    withAnimation(Animation.smooth(duration: 1)) {
                        error = nil
                        errorShowing = false
                        importWasSuccess = false
                        isImportViewShowing = true
                    }
                } label: {
                    HStack(alignment: .center) {
                        Text("Select CSV")
                        Image(systemName: "square.and.arrow.down.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                }
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isImportViewShowing) {
            DocumentPicker { result in
                switch result {
                case .success(let whiskeyFromCSV):
                    withAnimation(Animation.smooth(duration: 1)) {
                        self.whiskeysFromCSV = whiskeyFromCSV
                        importWasSuccess = true
                        whiskeyLibrary.collection.append(contentsOf: whiskeyFromCSV)
                    }
                case .failure(let error):
                    withAnimation(Animation.smooth(duration: 1)) {
                        self.error = error.localizedDescription
                        errorShowing = true
                        isImportViewShowing = false // Dismiss the full-screen cover
                        importWasSuccess = false
                    }
                }
            }
        }
        .navigationTitle("Import")
    }
}

#Preview {
    NavigationStack {
        CSVImportView()
            .navigationTitle("Import")
            .specialNavBar()

    }
}
