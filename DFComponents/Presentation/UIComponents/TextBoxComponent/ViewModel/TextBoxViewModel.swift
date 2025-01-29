//
//  TextBoxViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 29/01/2025.
//

import SwiftUI
import Combine

// MARK: - TextBoxViewModel
class TextBoxViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var errorMessage: String? = nil
    @Published var isValid: Bool = false
    @Published var selectedPrefix: String? = nil // Selected prefix
    @Published var selectedSuffix: String? = nil // Selected suffix

    var config: TextBoxConfiguration // Configuration for the text box
    var hasInteracted: Bool = false

    init(config: TextBoxConfiguration) {
        self.config = config
        // Set default prefix and suffix if only one option is provided
        if config.prefixOptions.count == 1 {
            selectedPrefix = config.prefixOptions.first
        }
        if config.suffixOptions.count == 1 {
            selectedSuffix = config.suffixOptions.first
        }
    }

    // Accessors for UI
    var title: String { config.title }
    var subtitle: String? { config.subtitle }
    var placeholder: String { config.placeholder }
    var prefixOptions: [String] { config.prefixOptions }
    var suffixOptions: [String] { config.suffixOptions }

    var borderColor: Color {
        if text.isEmpty {
            return .gray
        } else if hasInteracted {
            return isValid ? .green : .red
        }
        return .gray
    }

    // Validate input field and dropdown selections
    func validateInput() {
        hasInteracted = true

        // Validate prefix if required
        if config.requiresPrefix, selectedPrefix == nil {
            errorMessage = "Please select a prefix."
            isValid = false
            return
        }

        // Validate text based on input type
        switch config.inputType {
        case .numbersOnly:
            if !text.allSatisfy({ $0.isNumber }) {
                errorMessage = "Only numbers are allowed."
                isValid = false
                return
            }
        case .mixed:
            break
        }

        // Validate text length
        if text.count < config.minLength {
            errorMessage = "Minimum \(config.minLength) characters required."
            isValid = false
            return
        }

        // Validate suffix if required
        if config.requiresSuffix, selectedSuffix == nil {
            errorMessage = "Please select a suffix."
            isValid = false
            return
        }

        // If all validations pass
        errorMessage = nil
        isValid = true
    }

    func onEditingChanged(isEditing: Bool) {
        if isEditing {
            hasInteracted = true
        }
    }
}
