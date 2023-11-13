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
        NavigationStack {
            List {
                HStack(spacing: 0) {
                    Button {
                        isPhotoLibraryShowing = true
                    } label: {
                        VStack {
                            if whiskey.image == nil {
                                Image("noimageuploaded")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 75, height: 75)
                                    .shadow(radius: 4)
                            } else {
                                whiskey.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 75, height: 75)
                                    .shadow(color: .black, radius: 1)
                                    .padding(.leading, -10)
                            }
                            
                            if whiskey.avgScore != 0.0 {
                                ZStack {
                                    Rectangle()
                                        .strokeBorder(Color.lead, lineWidth: 4)
                                        .background(Rectangle().fill(Color.lead))
                                        .frame(width: 55, height: 55)
                                        .shadow(color: .gray, radius: 1)
                                    VStack {
                                        Text(String(format: "%.1f", whiskey.avgScore))
                                            .font(.custom("AsapCondensed-Bold", size: 26))
                                            .foregroundColor(.accentColor)
                                        Text("Overall")
                                            .font(.custom("AsapCondensed-Regular", size: 14))
                                    }
                                }
                                .frame(width: 45, height: 35)
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
                            .font(.custom("AsapCondensed-Bold", size: 72, relativeTo: .largeTitle))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .bold()
                        Text(whiskey.bottle)
                            .font(.custom("AsapCondensed-SemiBold", size: 48, relativeTo: .largeTitle))
                            .lineLimit(1)
                        
                    }
                    .frame(maxWidth: .infinity)
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
                        WhiskeyDetailRowView(title: "Proof", detail: "\(whiskey.proof)")
                        WhiskeyDetailRowView(title: "Purchase Date", detail: whiskey.purchasedDate.formatted(date: .abbreviated, time: .omitted))
                        WhiskeyDetailRowView(title: "Age", detail: whiskey.age.rawValue)
                        WhiskeyDetailRowView(title: "Origin", detail: whiskey.origin.rawValue)
                        WhiskeyDetailRowView(title: "Style", detail: whiskey.style.rawValue)
                        WhiskeyDetailRowStateToggle(title: "Bottle State", state: whiskey.bottleState)
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
                
                Section(isExpanded: $isTastingSectionExpanded) {
                    if whiskey.tastingNotes.isEmpty {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.black)
                                .border(Color.lead, width: 1)
                                .frame(height: 50)
                            Text("No Tastes")
                                .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                                .foregroundStyle(.gray)
                                .font(.callout)
                            
                        }
                    }
                    
                    ForEach(whiskey.tastingNotes) { taste in
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
            .listStyle(.plain)
            .listRowSpacing(-10)
            .navigationTitle("Whiskey Details")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    HStack {
                        if whiskey.opened && !whiskey.bottleFinished {
                            Button {
                                isAddTasteViewShowing.toggle()
                            } label: {
                                Image(systemName: "music.quarternote.3")
                            }
                        }
                        if !whiskey.bottleFinished {
                            Button {
                                isEditing.toggle()
                            } label: {
                                Image(systemName: "pencil.circle.fill")
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
                
            }
        }
    }
}

#Preview {
    WhiskeyDetailView(whiskey: WhiskeyLibrary(isForTesting: true).collection.first!)
}
