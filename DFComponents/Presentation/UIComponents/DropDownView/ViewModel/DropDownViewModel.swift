//
//  MainViewModel.swift
//  iOS Chanllenge
//
//  Created by ahmed maher.


import SwiftUI
import CoreLocation
import Combine

@MainActor
class DropDownViewModel: ObservableObject {

    @Published var countries: [Country] = []

    init() {
        initializeLocationAndData()
    }

    private func initializeLocationAndData() {
        Task {
            await fetchCountries()

        }
    }

    func filteredCountries(searchText: String) -> [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    @MainActor
    func fetchCountries() async {
         countries = [
            Country(name: "United States", capital: "Washington, D.C.", flag: "🇺🇸"),
            Country(name: "Canada", capital: "Ottawa", flag: "🇨🇦"),
            Country(name: "Japan", capital: "Tokyo", flag: "🇯🇵"),
            Country(name: "Germany", capital: "Berlin", flag: "🇩🇪"),
            Country(name: "Australia", capital: "Canberra", flag: "🇦🇺")
        ]

    }
}



