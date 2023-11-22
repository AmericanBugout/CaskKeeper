//
//  ImportWhiskeyCSVView.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/14/23.
//

import SwiftUI

struct ImportWhiskeyCSVView: View {
    @State private var isCSVImportShowing: Bool = false
    
    private let headers: [String: String] = [
        "Column 1": "label",
        "Column 2": "bottle",
        "Column 3": "style",
        "Column 4": "bottleState",
        "Column 5": "origin",
        "Column 6": "finish",
        "Column 7": "proof",
        "Column 8": "purchasedDate",
        "Column 9": "dateOpened",
        "Column 10": "locationPurhased",
        "Column 11": "price"
    ]
    
    private let stylestate = "style, bottleState"
    private let origin = "origin"
    private let purchased = "purchasedDate"
    private let opened = "dateOpened"
    
    var sortedHeaders: [(String, String)] {
        headers.sorted { a, b in
            guard let aNumber = Int(a.key.components(separatedBy: " ").last!),
                  let bNumber = Int(b.key.components(separatedBy: " ").last!) else {
                return false
            }
            return aNumber < bNumber
        }
    }
    
    var body: some View {
        List {
            Section {
                Text("CaskKeeper allows you to import a whiskey list from a csv file. Below are the following instructions for successfully loading a collection.")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                Text("This is best used when importing your collection for the first time.  After you start adding notes, using the JSON import may be the best option.")
                    .font(.custom("AsapCondensed-SemiBold", size: 18, relativeTo: .body))
            } header: {
                Text("Usage")
                    .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
            }
            .listRowSeparator(.hidden)
            
            Section {
                Text("Below are the required header values. They must be in the exact order and match the exact casing. Of course, the data should be comma seperated.")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 2) {
                    ForEach(Array(sortedHeaders), id: \.0) { key, value in
                        HStack {
                            Spacer()
                            Text(key)
                                .foregroundStyle(Color.accentColor)
                                .frame(maxWidth: 115, alignment: .leading)
                                .font(.custom("AsapCondensed-Regular", size: 16, relativeTo: .body))
                            Text(headers[key] ?? "")
                                .frame(maxWidth: 120, alignment: .leading)
                                .font(.custom("AsapCondensed-Light", size: 16, relativeTo: .body))
                            
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text("finish, purchasedDate, dateOpened, locationPurchased and price are optional.")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                Text("The header column is necessary. If no value exists for that field, leave the value as a blank")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
            } header: {
                Text("Required Header Row Values")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                
            }
            .listRowSeparator(.hidden)
            
            Section {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("In order for CaskKeeper to read your CSV. You will need to use certain values or data formats")
                        .frame(height: 60)
                        .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                    
                    
                    Group {
                        Text("For ")
                        + Text("\(stylestate)").foregroundColor(Color.blue)
                        + Text(" and ")
                        + Text("\(origin)").foregroundColor(Color.blue)
                        + Text(" use the below values")
                    }
                    .padding(.bottom)
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                    
                    CSVStyleView()
                    CSVBottleStateView()
                    CSVOriginView()
                    
                    Group {
                        Text("For ")
                        + Text("\(purchased)").foregroundColor(Color.blue)
                        + Text(" and ")
                        + Text("\(opened)").foregroundColor(Color.blue)
                        + Text(" use below format")
                    }
                    .padding(.vertical)
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
                    
                    CSVInfoValueRow(header: "purchasedDate", value: "\"mm/dd/yyyy\"")
                        .padding(.vertical, 3)
                    CSVInfoValueRow(header: "dateOpened", value: "\"mm/dd/yyyy\"")
                        .padding(.vertical, 3)
                }
            } header: {
                Text("Row Values")
                    .font(.custom("AsapCondensed-Light", size: 18, relativeTo: .body))
            }
            .listRowSeparator(.hidden)
            
            ZStack {
                NavigationLink {
                    CSVImportView()
                } label: {
                    EmptyView()
                }
                .opacity(0)
                
                HStack {
                    Text("Begin Import")
                        .font(.custom("AsapCondensed-Regular", size: 18, relativeTo: .body))
                    
                    Image(systemName: "square.and.arrow.down.fill")
                }
                .foregroundStyle(Color.accentColor)
                .padding(10)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 30)
            .padding(.bottom, 20)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Import Instructions")
    }
}



#Preview {
    ImportWhiskeyCSVView()
}
