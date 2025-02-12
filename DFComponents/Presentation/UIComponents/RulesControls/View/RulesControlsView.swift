//
//  RulesControlsView.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

import SwiftUI

struct RulesControlsView: View {
    @EnvironmentObject var viewModel: RulesControlsViewModel
    var body: some View {
        VStack(spacing: 10) {
                ControlFormBuilderView(titleControl: "First Name") {
                    FormFieldView(
                        text: $viewModel.firstName,
                        error: $viewModel.firstNameError,
                        placeholder: "Enter your first name",
                        isValid: viewModel.firstNameError == nil && !viewModel.firstName.isEmpty
                    )
                }
                ControlFormBuilderView(titleControl: "Last Name") {
                    FormFieldView(
                        text: $viewModel.lastName,
                        error: $viewModel.lastNameError,
                        placeholder: "Enter your last name",
                        isValid: viewModel.lastNameError == nil && !viewModel.lastName.isEmpty
                    )
                }
                ControlFormBuilderView(titleControl: "Full Name") {
                    if viewModel.firstNameError == nil && viewModel.lastNameError == nil {
                        Text(viewModel.fullName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom, 8)
                    } else {
                        ErrorMessageView(errorMessage: "Invalid name entries", imageName: "xmark.circle.fill")
                    }
                }
                .padding(.vertical, 10)
                ControlFormBuilderView(titleControl: "Email") {
                    FormFieldView(
                        text: $viewModel.email,
                        error: $viewModel.emailError,
                        placeholder: "Enter your email",
                        isValid: viewModel.emailError == nil && !viewModel.email.isEmpty,
                        isEmailField: true
                    )
                }
                ControlFormBuilderView(titleControl: "Confirm Email") {
                    FormFieldView(
                        text: $viewModel.confirmEmail,
                        error: $viewModel.confirmEmailError,
                        placeholder: "Confirm your email",
                        isValid: viewModel.isEmailMatching && (viewModel.confirmEmailError == nil && !viewModel.confirmEmail.isEmpty),
                        isEmailConfirmField: true
                    )
            }
        }
        .padding(.horizontal, 0)
    }
}

#Preview {
    RulesControlsView()
        .environmentObject(RulesControlsViewModel())
}

