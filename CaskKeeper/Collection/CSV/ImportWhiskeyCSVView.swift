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
        "Column 8": "age",
        "Column 9": "purchasedDate",
        "Column 10": "dateOpened",
        "Column 11": "locationPurchased",
        "Column 12": "price"
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
                    .font(.customLight(size: 18))
                Text("This is best used when importing your collection for the first time.  After you start adding notes, using the JSON import may be the best option.")
                    .font(.customSemiBold(size: 18))
            } header: {
                Text("Usage")
                    .font(.customRegular(size: 18))
            }
            .listRowSeparator(.hidden)
            
            Section {
                Text("Below are the required header values. They must be in the exact order and match the exact casing. Of course, the data should be comma seperated.")
                    .font(.customLight(size: 18))
                
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 2) {
                    ForEach(Array(sortedHeaders), id: \.0) { key, value in
                        HStack {
                            Spacer()
                            Text(key)
                                .foregroundStyle(Color.accentColor)
                                .frame(maxWidth: 115, alignment: .leading)
                                .font(.customRegular(size: 16))
                            Text(headers[key] ?? "")
                                .frame(maxWidth: 120, alignment: .leading)
                                .font(.customLight(size: 16))
                            
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text("finish, purchasedDate, dateOpened, locationPurchased, age, and price are optional.")
                    .font(.customLight(size: 18))
                Text("The header column is necessary. If no value exists for that field, leave the value as blank")
                    .font(.customLight(size: 18))
            } header: {
                Text("Required Header Row Values")
                    .font(.customLight(size: 18))
                
            }
            .listRowSeparator(.hidden)
            
            Section {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("In order for CaskKeeper to read your CSV. You will need to use certain values or data formats")
                        .frame(height: 60)
                        .font(.customLight(size: 18))
                    
                    
                    Group {
                        Text("For ")
                        + Text("\(stylestate)").foregroundColor(Color.blue)
                        + Text(" and ")
                        + Text("\(origin)").foregroundColor(Color.blue)
                        + Text(" use the below values")
                    }
                    .padding(.bottom)
                    .font(.customLight(size: 18))
                    
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
                    .font(.customLight(size: 18))
                    //"M/d/yyyy"
                    
                    CSVInfoValueRow(header: "purchasedDate", value: "\"M/d/yyyy\"")
                        .padding(.vertical, 3)
                    CSVInfoValueRow(header: "dateOpened", value: "\"M/d/yyyy\"")
                        .padding(.vertical, 3)
                }
            } header: {
                Text("Row Values")
                    .font(.customLight(size: 18))
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
                        .font(.customRegular(size: 18))
                    
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
