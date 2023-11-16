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
    
    var body: some View {
        ZStack {
            VStack {
                
                VStack {
                    VStack {

                        Text("\(whiskeysFromCSV.count)")
                            .font(.custom("AsapCondensed-Bold", size: 72, relativeTo: .body))
                            .opacity(importWasSuccess ? 1 : 0)
                            .scaleEffect(importWasSuccess ? 1 : 0.9)
                            .rotationEffect(importWasSuccess ? Angle(degrees: 0) : Angle(degrees: -10))
                            .foregroundStyle(importWasSuccess ? .green : .gray)
                            .transition(AnyTransition(.slide))
                            .offset(y: importWasSuccess ? 0 : -500)
                        HStack {
                            Text("Imported Whiskeys".uppercased())
                                .font(.custom("AsapCondensed-Regular", size: 24, relativeTo: .body))
                                .foregroundStyle(.gray)
                            Image(systemName: importWasSuccess ? "checkmark.circle.fill" : "circle")
                                .opacity(importWasSuccess ? 1 : 0)
                                .scaleEffect(importWasSuccess ? 1 : 0.9)
                                .rotationEffect(importWasSuccess ? Angle(degrees: 0) : Angle(degrees: -10))
                                .foregroundStyle(importWasSuccess ? .green : .gray)
                        }
                        .offset(x: importWasSuccess ? 0 : 10)
                    }
                }
                .frame(height: 300)
                
                
                Button {
                    isImportViewShowing = true
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
                        whiskeyLibrary.collection = whiskeysFromCSV
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        .navigationTitle("Import")
    }
}

#Preview {
    CSVImportView()
}
