//
//  TextBoxViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 29/01/2025.
//

import SwiftUI

// MARK: - TextBoxViewModel
class TextBoxViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var errorMessage: String?
    @Published var isValid: Bool = false
    @Published var selectedPrefix: String?
    @Published var selectedSuffix: String?
    var mask: String = "9(999)-9999"  // Ex
    let config: TextBoxDTO
    var hasInteracted: Bool = false

    init(config: TextBoxDTO = TextBoxViewModel.defaultConfig) {
        self.config = config

        // Set default prefix and suffix if only one option is available
        selectedPrefix = config.prefixOptions.count == 1 ? config.prefixOptions.first : nil
        selectedSuffix = config.suffixOptions.count == 1 ? config.suffixOptions.first : nil
    }

    // Default configuration
    static var defaultConfig: TextBoxDTO {
        return TextBoxDTO(
            title: "Mobile Number",
            subtitle: nil,
            placeholder: "Enter your mobile number",
            inputType: .mixed,
            minLength: 2,
            prefixOptions: [],
            suffixOptions: [],
            requiresPrefix: true,
            requiresSuffix: true
        )
    }

    // MARK: - UI Accessors
    var title: String { config.title }
    var subtitle: String? { config.subtitle }
    var placeholder: String { config.placeholder }
    var prefixOptions: [String] { config.prefixOptions }
    var suffixOptions: [String] { config.suffixOptions }

    var borderColor: Color {
        guard !text.isEmpty else { return Color(hex: "#D0D9E2") }
        return hasInteracted ? (isValid ? .green : .red) : Color(hex: "#D0D9E2")
    }

    // MARK: - Validation
    func validateInput() {
        hasInteracted = true
        // Clear the error message if text is empty
        if text.isEmpty {
            errorMessage = nil
            isValid = false
            return
        }
        // Reset the error message before validation
        errorMessage = nil

        if config.inputType == .numbersOnly, !text.allSatisfy({ $0.isNumber }) {
            errorMessage = "Only numbers are allowed."
        } else if text.count < config.minLength {
            errorMessage = "Minimum \(config.minLength) characters required."
        }
        isValid = errorMessage == nil
    }

    func onEditingChanged(isEditing: Bool) {
        if isEditing { hasInteracted = true }
    }
}
