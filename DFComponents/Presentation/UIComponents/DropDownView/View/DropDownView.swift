//
//  DropDownView.swift
//  DFComponents
//
//  Created by ahmed maher on 29/01/2025.
//

import SwiftUI

struct DropDownView: View {
    let title: String
    @ObservedObject var viewModel: DropDownViewModel
    @State private var isBottomSheetPresented = false

    var body: some View {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
                Image(systemName: "chevron.down.circle.fill")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .onTapGesture {
                        withAnimation {
                            isBottomSheetPresented.toggle()
                        }
                    }
            }
            .padding()
            .background(
                      RoundedRectangle(cornerRadius: 8)
                          .stroke(Color.gray, lineWidth: 1)
                  )

            .sheet(isPresented: $isBottomSheetPresented) {
                BottomSheetView(viewModel: viewModel)
            }

    }
}

struct BottomSheetView: View {
    @ObservedObject var viewModel: DropDownViewModel
    @State private var searchText = ""

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List(viewModel.filteredCountries(searchText: searchText)) { country in
                HStack {
                    VStack(alignment: .leading) {
                        Text(country.name)
                            .font(.headline)
                        Text("Capital: \(country.capital )")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                }
                .padding(.vertical, 4)
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top, 20)
    }
}



