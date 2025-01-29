//
//  TextBoxViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 29/01/2025.
//

import SwiftUI
import Combine

class TextBoxViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var errorMessage: String? = nil
    @Published var isValid: Bool = false

    var config: TextBoxConfiguration  // Allows read-only access outside the class
    var hasInteracted: Bool = false

    init(config: TextBoxConfiguration) {
        self.config = config
    }

    var title: String { config.title }
    var subtitle: String? { config.subtitle }
    var placeholder: String { config.placeholder }
    var prefix: String? { config.prefix }
    var suffix: String? { config.suffix }

    var borderColor: Color {
        if text.isEmpty {
            return .gray
        } else if hasInteracted {
            return isValid ? .green : .red
        }
        return .gray
    }

    func validateInput() {
        hasInteracted = true

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

        if text.count < config.minLength {
            errorMessage = "Minimum \(config.minLength) characters required."
            isValid = false
        } else {
            errorMessage = nil
            isValid = true
        }
    }

    func onEditingChanged(isEditing: Bool) {
        if isEditing {
            hasInteracted = true
        }
    }
}

