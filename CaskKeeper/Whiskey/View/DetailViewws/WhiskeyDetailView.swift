//
//  WhiskeyDetailView.swift
//  WhiskeyNotes
//
//  Created by Jon Oryhan on 10/29/23.
//

import SwiftUI
import UIKit

struct WhiskeyDetailView: View {
    @Environment(\.whiskeyLibrary) private var whiskeyLibrary
    @AppStorage("showImages") var showImages: Bool = true
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing: Bool = false
    @State private var isPhotoLibraryShowing: Bool = false
    @State private var isDetailSectionExpanded: Bool = true
    @State private var isTastingSectionExpanded: Bool = true
    @State private var isAddTasteViewShowing: Bool = false
    @State private var showActionSheet = false
    @State private var indexToDelete: Int?
    @State var whiskey: Whiskey
    @State private var image: UIImage?
    
    var nonOptionalImageBinding: Binding<UIImage> {
        Binding<UIImage>(
            get: { self.image ?? UIImage() },
            set: { self.image = $0 }
        )
    }
    
    var body: some View {
        List {
            HStack(spacing: 0) {
                Button {
                    isPhotoLibraryShowing = true
                } label: {
                    VStack {
                        if showImages {
                            if whiskey.image == nil {
                                Image("noimageuploaded")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 115, height: 115)
                                    .shadow(color: .black, radius: 1)
                                    .padding(.leading, -10)
                            } else {
                                whiskey.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 115, height: 115)
                                    .shadow(color: .black, radius: 1)
                                    .padding(.leading, -10)
                            }
                        }
                        
                        if whiskey.avgScore != 0.0 {
                            ZStack {
                                Rectangle()
                                    .strokeBorder(Color.lead, lineWidth: 4)
                                    .background(Rectangle().fill(Color.lead))
                                    .frame(width: 55, height: 55)
                                    .shadow(color: .aluminum, radius: 1)
                                VStack {
                                    Text(String(format: "%.1f", whiskey.avgScore))
                                        .font(.custom("AsapCondensed-Bold", size: 26))
                                        .foregroundColor(.accentColor)
                                    Text("Overall")
                                        .font(.custom("AsapCondensed-Regular", size: 14))
                                }
                            }
                            .frame(width: 45, height: 45)
                            .offset(x: showImages ? 0 : 40, y: showImages ? 0 : 20)
                            .padding(.leading, -10)
                            .padding(.bottom, 4)
                        }
                    }
                }
                .frame(width: 75, height: 75, alignment: .leading)
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text(whiskey.label)
                        .font(.custom("AsapCondensed-Bold", size: 52, relativeTo: .largeTitle))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .offset(x: showImages ? 0 : -40)
                    Text(whiskey.bottle)
                        .font(.custom("AsapCondensed-SemiBold", size: 42, relativeTo: .largeTitle))
                        .lineLimit(1)
                        .padding(.bottom, 1)
                        .offset(x: showImages ? 0 : -40)
                    Text(whiskey.bottleState.currentState.uppercased())
                        .padding(.horizontal)
                        .foregroundStyle(whiskey.bottleState.color)
                        .font(.custom("AsapCondensed-SemiBold", size: 28, relativeTo: .largeTitle))
                        .offset(x: showImages ? 0 : -40)


                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 15)
                Spacer()
                
            }
            .listRowSeparator(.hidden)
            .sheet(isPresented: $isPhotoLibraryShowing, content: {
                ZStack {
                    PHPickerRepresentable(selectedImage: nonOptionalImageBinding)
                        .ignoresSafeArea()
                }
            })
            .onChange(of: image, { oldValue, newValue in
                if let newImage = newValue {
                    if let imageData = newImage.jpegData(compressionQuality: 0.3) {
                        whiskeyLibrary.updateImage(for: whiskey, with: imageData)
                    }
                }
            })
            
            Section(isExpanded: $isDetailSectionExpanded) {
                Group {
                    WhiskeyDetailRowView(title: "Label", detail: whiskey.label)
                    WhiskeyDetailRowView(title: "Bottle", detail: whiskey.bottle)
                    WhiskeyDetailRowView(title: "Batch #", detail: whiskey.batch)
                        .foregroundStyle(whiskey.batch.isEmpty ? Color.secondary : Color.primary)
                    WhiskeyDetailRowProofView(title: "Proof", detail: whiskey.proof)
                    if let purchasedDate = whiskey.purchasedDate {
                        WhiskeyDetailRowView(title: "Purchased Date", detail: purchasedDate.formatted(date: .abbreviated, time: .omitted))
                    }
                    WhiskeyDetailRowAgeView(title: "Age", detail: whiskey.age ?? 0)
                    WhiskeyDetailRowView(title: "Origin", detail: whiskey.origin.rawValue)
                    WhiskeyDetailRowView(title: "Style", detail: whiskey.style.rawValue)
                    WhiskeyDetailRowView(title: "Finish", detail: whiskey.finish)
                        .foregroundStyle(whiskey.batch.isEmpty ? Color.secondary : Color.primary)
                    if let openedDate = whiskey.dateOpened {
                        WhiskeyDetailRowView(title: "Opened Date", detail: openedDate.formatted(date: .abbreviated, time: .omitted))
                    }
                    
                    if let consumedDate = whiskey.consumedDate {
                        WhiskeyDetailRowView(title: "Consumed Date", detail: consumedDate.formatted(date: .abbreviated, time: .omitted))
                    }
                    if whiskey.firstOpen == false || whiskey.opened {
                        WhiskeyDetailRowView(title: "Opened For", detail: whiskey.openedFor)
                    }
                    
                    WhiskeyDetailRowViewToggle(title: "Buy Again", isEnabled: whiskey.wouldBuyAgain)
                    WhiskeyDetailRowView(title: "Location Purchased", detail: whiskey.locationPurchased)
                        .foregroundStyle(whiskey.locationPurchased.isEmpty ? Color.secondary : Color.primary)
                    WhiskeyDetailPriceView(title: "Price", detail: whiskey.price ?? 0)
                }
            } header: {
                HStack(alignment: .bottom) {
                    Text("Whiskey Details")
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                    Spacer()
                    Button {
                        withAnimation(Animation.smooth) {
                            isDetailSectionExpanded.toggle()
                        }
                    } label:  {
                        Image(systemName: "chevron.right")
                    }
                    .animation(.smooth(), value: isDetailSectionExpanded)
                    .rotationEffect(isDetailSectionExpanded ? Angle(degrees: 90) : Angle(degrees: 0))
                }
            }
            .listRowInsets(.init(top: 2, leading: 5, bottom: 10, trailing: 10))
            .listRowSeparator(.hidden)
            .listSectionSpacing(0)
            
            if !whiskey.tastingNotes.isEmpty {
                Section(isExpanded: $isTastingSectionExpanded) {
                    ForEach(whiskey.tastingNotes, id: \.self) { taste in
                        Section {
                            ZStack {
                                NavigationLink {
                                    WhiskeyTasteDetailView(taste: taste)
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                                TasteRowView(taste: taste)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listRowInsets(.init(top: 10, leading: 5, bottom: 10, trailing: 10))
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { index in
                        whiskeyLibrary.deleteTasting(whiskey: whiskey, indexSet: index)
                    }
                } header: {
                    HStack(alignment: .bottom) {
                        Text("Whiskey Notes")
                            .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                        Spacer()
                        Button {
                            withAnimation(Animation.smooth) {
                                isTastingSectionExpanded.toggle()
                            }
                        } label:  {
                            Image(systemName: "chevron.right")
                        }
                        .animation(.smooth(), value: isTastingSectionExpanded)
                        .rotationEffect(isTastingSectionExpanded ? Angle(degrees: 90) : Angle(degrees: 0))
                    }
                    .listRowBackground(Color.clear)
                }
                .listRowInsets(.init(top: 0, leading: 5, bottom: 10, trailing: 10))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .listRowSpacing(-10)
        .navigationTitle("Whiskey Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack(spacing: 20) {
                    if whiskey.bottleState == .opened {
                        Button {
                            isAddTasteViewShowing.toggle()
                        } label: {
                            Image(systemName: "music.quarternote.3")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .sheet(isPresented: $isEditing) {
                    WhiskeyEditView(whiskey: $whiskey)
                }
                .sheet(isPresented: $isAddTasteViewShowing) {
                    AddWhiskeyNote(whiskey: whiskey)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if whiskey.bottleState != .finished {
                    Button {
                        isEditing = true
                    } label: {
                        VStack {
                            Image(systemName: "pencil")
                        }
                        
                    }
                }
            }
        }
    }
    
    func formattedAgeString(from age: Double) -> String {
        return age.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", age) : String(age)
    }
    
}

#Preview {
    WhiskeyDetailView(whiskey: WhiskeyLibrary(isForTesting: true).collection.first!)
}
