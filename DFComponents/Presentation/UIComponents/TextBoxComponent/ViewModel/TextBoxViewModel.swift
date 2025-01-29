//
//  TextBoxViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 29/01/2025.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

// MARK: - TextBoxViewModel
class TextBoxViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var errorMessage: String?
    @Published var isValid: Bool = false
    @Published var selectedPrefix: String?
    @Published var selectedSuffix: String?
    
    let config: TextBoxConfiguration
    var hasInteracted: Bool = false

    init(config: TextBoxConfiguration) {
        self.config = config
        
        // Set default prefix and suffix if only one option is available
        selectedPrefix = config.prefixOptions.count == 1 ? config.prefixOptions.first : nil
        selectedSuffix = config.suffixOptions.count == 1 ? config.suffixOptions.first : nil
    }

    // MARK: - UI Accessors
    var title: String { config.title }
    var subtitle: String? { config.subtitle }
    var placeholder: String { config.placeholder }
    var prefixOptions: [String] { config.prefixOptions }
    var suffixOptions: [String] { config.suffixOptions }

    var borderColor: Color {
        guard !text.isEmpty else { return .gray }
        return hasInteracted ? (isValid ? .green : .red) : .gray
    }

    // MARK: - Validation
    func validateInput() {
        hasInteracted = true
        errorMessage = nil

        if config.requiresPrefix, selectedPrefix == nil {
            errorMessage = "Please select a prefix."
        } else if config.inputType == .numbersOnly, !text.allSatisfy({ $0.isNumber }) {
            errorMessage = "Only numbers are allowed."
        } else if text.count < config.minLength {
            errorMessage = "Minimum \(config.minLength) characters required."
        } else if config.requiresSuffix, selectedSuffix == nil {
            errorMessage = "Please select a suffix."
        }

        isValid = errorMessage == nil
    }

    func onEditingChanged(isEditing: Bool) {
        if isEditing { hasInteracted = true }
    }
}
