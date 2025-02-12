//
//  TextBoxComponent.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 28/01/2025.

import SwiftUI

// MARK: - TextBoxComponent
struct TextBoxComponent: View {
    @ObservedObject var viewModel: TextBoxViewModel
    @EnvironmentObject var styleManagerVM: StyleManagerViewModel
    var isDisabled: Bool = false // Add this line

    var body: some View {
        let styleManager = styleManagerVM.styleManager

        VStack(alignment: .leading, spacing: styleManager.innerPadding) {
            // Title and Subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title)
                    .styledText(font: styleManager.titleFont, color: isDisabled ? styleManager.disabledTextColor : styleManager.primaryTextColor)

                if let subtitle = viewModel.subtitle {
                    Text(subtitle)
                        .styledText(font: styleManager.subtitleFont, color: isDisabled ? styleManager.disabledTextColor.opacity(0.7) : styleManager.secondaryTextColor)
                }
            }
            .padding(.bottom, styleManager.innerPadding)

            // Input Field with Prefix and Suffix
            HStack {
                // Prefix
                if !viewModel.prefixOptions.isEmpty {
                    CustomDropdownView(
                        selectedOption: $viewModel.selectedPrefix,
                        options: viewModel.prefixOptions,
                        label: "Prefix",
                        borderColor: viewModel.borderColor
                    )
                    .disabled(isDisabled) // Use isDisabled here
                    .opacity(isDisabled ? 0.6 : 1.0)
                }

                TextField(viewModel.placeholder, text: $viewModel.text, onEditingChanged: { isEditing in
                    if !isDisabled {
                        viewModel.onEditingChanged(isEditing: isEditing)
                    }
                })
                .padding()
                .frame(height: 48)
                .styledBorder(color: viewModel.borderColor, width: styleManager.borderWidth, cornerRadius: styleManager.cornerRadius)
                .background(
                    RoundedRectangle(cornerRadius: styleManager.cornerRadius)
                        .fill(isDisabled ? styleManager.disabledBackgroundColor : Color.clear)
                )
                .disabled(isDisabled) // Use isDisabled here
                .opacity(isDisabled ? 0.6 : 1.0)
                .keyboardType(viewModel.config.inputType == .numbersOnly ? .numberPad : .default)
                .onChange(of: viewModel.text) { _ in
                    if !isDisabled {
                        viewModel.validateInput()
                    }
                }

                // Suffix
                if !viewModel.suffixOptions.isEmpty {
                    CustomDropdownView(
                        selectedOption: $viewModel.selectedSuffix,
                        options: viewModel.suffixOptions,
                        label: "Suffix",
                        borderColor: viewModel.borderColor
                    )
                    .disabled(isDisabled) // Use isDisabled here
                    .opacity(isDisabled ? 0.6 : 1.0)
                }
            }

            // Error Message
            if let errorMessage = viewModel.errorMessage, viewModel.hasInteracted, !isDisabled {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(styleManager.errorColor)
                    Text(errorMessage)
                        .styledText(font: styleManager.errorFont, color: styleManager.errorColor)
                }
            }
        }
        .padding(styleManager.componentPadding)
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


