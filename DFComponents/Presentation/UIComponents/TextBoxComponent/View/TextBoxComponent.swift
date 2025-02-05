//
//  TextBoxComponent.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 28/01/2025.

import SwiftUI

// MARK: - TextBoxComponent
struct TextBoxComponent: View {
    @ObservedObject var viewModel: TextBoxViewModel
    @State private var text: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Title and Subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title)
                    .font(.headline)
                if let subtitle = viewModel.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom)

            // Input Field with Prefix and Suffix
            HStack {
                // Prefix
                if !viewModel.prefixOptions.isEmpty {
                    CustomDropdownView(selectedOption: $viewModel.selectedPrefix, options: viewModel.prefixOptions, label: "Prefix",
                        borderColor: viewModel.borderColor
                    )
                }
                MaskTextField(text: $text, mask: viewModel.mask)  // Pass mask from ViewModel
                .padding()
                .frame(height: 48)
                .background(RoundedRectangle(cornerRadius: 8)
                .stroke(viewModel.borderColor, lineWidth: 2))
                .keyboardType(viewModel.config.inputType == .numbersOnly ? .numberPad : .default)
                .onChange(of: text) { _ in
                    viewModel.validateInput()
                }
                // Suffix
                if !viewModel.suffixOptions.isEmpty {
                    CustomDropdownView(selectedOption: $viewModel.selectedSuffix, options: viewModel.suffixOptions, label: "Suffix",
                        borderColor: viewModel.borderColor
                    )
                }
            }

            // Error Message
            if let errorMessage = viewModel.errorMessage, viewModel.hasInteracted {
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
}

// MARK: - Preview
#Preview {
    let config = TextBoxDTO(
        title: "Phone Number",
        subtitle: "Enter a valid number",
        placeholder: "XXX-XXX-XXXX",
        inputType: .mixed,
        minLength: 10,
        prefixOptions: ["Mr", "Ms"],
        suffixOptions: ["Jr"],
        requiresPrefix: true,
        requiresSuffix: true
    )
    return TextBoxComponent(viewModel: TextBoxViewModel(config: config))
}


