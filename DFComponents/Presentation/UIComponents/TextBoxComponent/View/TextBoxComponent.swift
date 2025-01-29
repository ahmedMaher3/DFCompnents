//
//  TextBoxComponent.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 28/01/2025.

import SwiftUI

struct TextBoxComponent: View {
    let title: String
    let subtitle: String?
    let placeholder: String
    let inputType: TextBoxInputFieldType
    let minLength: Int

    @State private var text: String = ""
    @State private var errorMessage: String? = nil
    @State private var isValid: Bool = false
    @State private var hasInteracted: Bool = false  // Track user interaction

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Title and Subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                if let subtitle = subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            // TextField with Validation
            TextField(placeholder, text: $text, onEditingChanged: { isEditing in
                if isEditing {
                    hasInteracted = true  // Track first user interaction
                }
            })
            .padding()
            .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 2))
            .keyboardType(inputType == .numbersOnly ? .numberPad : .default)
            .onChange(of: text) { newValue in
                validateInput(newValue)
            }

            // Error Message
            if let errorMessage = errorMessage, hasInteracted {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }

    // Determine Border Color
    private var borderColor: Color {
        if text.isEmpty {
            return .gray  // Default gray when empty
        } else if hasInteracted {
            return isValid ? .green : .red  // Change color based on validation
        }
        return .gray
    }

    // Validation Logic
    private func validateInput(_ input: String) {
        // Check input type
        switch inputType {
        case .numbersOnly:
            if !input.allSatisfy({ $0.isNumber }) {
                errorMessage = "Only numbers are allowed."
                isValid = false
                return
            }
        case .mixed:
            break
        }

        // Check minimum length
        if input.count < minLength {
            errorMessage = "You entered characters less than the minimum required (\(minLength))."
            isValid = false
        } else {
            errorMessage = nil
            isValid = true
        }
    }
}

#Preview {
    TextBoxComponent(title: "Contractor name", subtitle: "Enter name", placeholder: "Contractor name", inputType: .mixed, minLength: 2)
}
