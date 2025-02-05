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
                Text(viewModel.selectedCountry?.name ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                Spacer()
                Image("Mask")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)

            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isBottomSheetPresented.toggle()
                }
            }

            .sheet(isPresented: $isBottomSheetPresented) {
                BottomSheetView(viewModel: viewModel, isBottomSheetPresented: $isBottomSheetPresented)
            }

    }
}


struct BottomSheetView: View {
    @ObservedObject var viewModel: DropDownViewModel
    @State private var searchText = ""
    @Binding var isBottomSheetPresented: Bool

    var body: some View {
        VStack {
            VStack (alignment: .leading){
                Text("Where do you live ")
                    .font(.title3)
                    .padding(.top,25)
                    .padding(.horizontal,20)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .padding(.vertical, 10)
            }
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
                .onTapGesture {
                    viewModel.selectCountry(country)
                    isBottomSheetPresented = false
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}



