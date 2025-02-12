//
//  DataFlowViewModel.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

import SwiftUI
class DataFlowViewModel: ObservableObject {
    @Published var firstName = "" {
        didSet { validateFirstName() }
    }
    @Published var lastName = "" {
        didSet { validateLastName() }
    }
    @Published var email = "" {
        didSet { validateEmail() }
    }
    @Published var confirmEmail = "" {
        didSet { validateConfirmEmail() }
    }

    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var emailError: String? = nil
    @Published var confirmEmailError: String? = nil

    var fullName: String {
        if firstNameError != nil || lastNameError != nil {
            return ""
        }
        return firstName + " " + lastName
    }

    var isEmailMatching: Bool {
        return email == confirmEmail
    }

    func validateFirstName() {
        if firstName.contains(" ") {
            firstNameError = "First name must be one word."
        } else {
            firstNameError = nil
        }
    }

    func validateLastName() {
        if lastName.contains(" ") {
            lastNameError = "Last name must be one word."
        } else {
            lastNameError = nil
        }
    }

    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)

        if !emailTest.evaluate(with: email) {
            emailError = "Please enter a valid email address."
        } else {
            emailError = nil
        }
    }

    func validateConfirmEmail() {
        if confirmEmail.isEmpty {
            confirmEmailError = "Please confirm your email."
        } else if !isEmailMatching {
            confirmEmailError = "Emails do not match."
        } else {
            confirmEmailError = nil
        }
    }
}
