//
//  BaseFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 17/03/2025.
//
import Foundation

final class BaseFieldViewModel: ObservableObject {
    @Published var errorMessage: String? = ""

    init(errorMessage: String = "") {
        self.errorMessage = errorMessage
    }
}
