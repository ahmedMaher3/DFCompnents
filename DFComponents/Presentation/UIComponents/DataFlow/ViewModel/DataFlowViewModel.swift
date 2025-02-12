//
//  DataFlowViewModel.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

import SwiftUI
class DataFlowViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    var fullName: String {
        return firstName + " " + lastName
    }
}
