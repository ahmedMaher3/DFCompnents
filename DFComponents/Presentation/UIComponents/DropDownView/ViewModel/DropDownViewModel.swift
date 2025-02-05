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

    @Published var countries: [CountryDTO] = []
    @Published var selectedCountry: CountryDTO?

    init() {
        initializeLocationAndData()
    }

    private func initializeLocationAndData() {
        Task {
            await fetchCountries()

        }
    }

    func selectCountry(_ country: CountryDTO) {
           selectedCountry = country
       }

    func filteredCountries(searchText: String) -> [CountryDTO] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    @MainActor
    func fetchCountries() async {
         countries = [
            CountryDTO(name: "United States", capital: "Washington, D.C.", flag: "🇺🇸"),
            CountryDTO(name: "Canada", capital: "Ottawa", flag: "🇨🇦"),
            CountryDTO(name: "Japan", capital: "Tokyo", flag: "🇯🇵"),
            CountryDTO(name: "Germany", capital: "Berlin", flag: "🇩🇪"),
            CountryDTO(name: "Australia", capital: "Canberra", flag: "🇦🇺")
        ]

    }
}



