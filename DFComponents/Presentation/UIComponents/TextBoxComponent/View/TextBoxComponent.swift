//
//  TextBoxComponent.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 28/01/2025.

import SwiftUI

// MARK: - TextBoxComponent
import SwiftUI

// MARK: - TextBoxComponent
struct TextBoxComponent: View {
    @ObservedObject var viewModel: TextBoxViewModel
    
    private func getTextFieldColor(for selection: String?) -> Color {
        return (selection == nil || selection?.isEmpty == true) ? Color(hex: "9EB3C2") : Color.black
    }
    
    private func createPrefixView() -> some View {
        let prefixColor = getTextFieldColor(for: viewModel.selectedPrefix)

        if viewModel.prefixOptions.count == 1, let prefix = viewModel.selectedPrefix {
            return AnyView(
                Text(prefix)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .foregroundColor(prefixColor)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#D0D9E2"), lineWidth: 1))
            )
        } else {
            return AnyView(
                Menu {
                    ForEach(viewModel.prefixOptions, id: \.self) { option in
                        Button(action: {
                            viewModel.selectedPrefix = option
                            viewModel.validateInput()
                        }) {
                            Text(option)
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedPrefix ?? "Prefix")
                            .foregroundColor(prefixColor)
                        if viewModel.prefixOptions.count > 1 {
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color(hex: " #173E67"))
                        }
                    }
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#D0D9E2"), lineWidth: 1))
                }
            )
        }
    }
    
    private func createSuffixView() -> some View {
        let suffixColor = getTextFieldColor(for: viewModel.selectedSuffix)

        if viewModel.suffixOptions.count == 1, let suffix = viewModel.selectedSuffix {
            return AnyView(
                Text(suffix)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .foregroundColor(suffixColor)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#D0D9E2"), lineWidth: 1))
            )
        } else {
            return AnyView(
                Menu {
                    ForEach(viewModel.suffixOptions, id: \.self) { option in
                        Button(action: {
                            viewModel.selectedSuffix = option
                            viewModel.validateInput()
                        }) {
                            Text(option)
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedSuffix ?? "Suffix")
                            .foregroundColor(suffixColor)
                        if viewModel.suffixOptions.count > 1 {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#D0D9E2"), lineWidth: 1))
                }
            )
        }
    }
    
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

            // Input Field with Prefix and Suffix
            HStack {
                // Prefix
                if !viewModel.prefixOptions.isEmpty {
                    createPrefixView()
                }

                // Text Field
                TextField(viewModel.placeholder, text: $viewModel.text, onEditingChanged: { isEditing in
                    viewModel.onEditingChanged(isEditing: isEditing)
                })
                .padding()
                .frame(height: 48)
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.borderColor, lineWidth: 2))
                .keyboardType(viewModel.config.inputType == .numbersOnly ? .numberPad : .default)
                .onChange(of: viewModel.text) { _ in
                    viewModel.validateInput()
                }

                // Suffix
                if !viewModel.suffixOptions.isEmpty {
                    createSuffixView()
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
    let config = TextBoxConfiguration(
        title: "What is your Name?",
        subtitle: nil,
        placeholder: "Enter your name",
        inputType: .mixed,
        minLength: 2,
        prefixOptions: ["Mr", "Ms"],
        suffixOptions: ["Jr"],
        requiresPrefix: true,
        requiresSuffix: true
    )
    return TextBoxComponent(viewModel: TextBoxViewModel(config: config))
}
