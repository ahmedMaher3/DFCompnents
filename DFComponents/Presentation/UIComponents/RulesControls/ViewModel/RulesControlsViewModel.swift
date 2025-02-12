//
//  RulesControlsViewModel.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

import SwiftUI
class RulesControlsViewModel: ObservableObject {
    @Published var firstName = "" {
        didSet { validateField(field: "firstName", value: firstName) }
    }
    @Published var lastName = "" {
        didSet { validateField(field: "lastName", value: lastName) }
    }
    @Published var email = "" {
        didSet { validateField(field: "email", value: email) }
    }
    @Published var confirmEmail = "" {
        didSet { validateField(field: "confirmEmail", value: confirmEmail) }
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

    // Validation function for all fields
    func validateField(field name: String, value: String) {
        let validationRules: [String: (String) -> String?] = [
            "firstName": { value in
                if value.isEmpty {
                    return "First name is required."
                } else if value.contains(" ") {
                    return "First name must be one word."
                }
                return nil
            },
            "lastName": { value in
                if value.isEmpty {
                    return "Last name is required."
                } else if value.contains(" ") {
                    return "Last name must be one word."
                }
                return nil
            },
            "email": { value in
                if value.isEmpty {
                    return "Email is required."
                } else {
                    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                    if !emailTest.evaluate(with: value) {
                        return "Please enter a valid email address."
                    }
                }
                return nil
            },
            "confirmEmail": { value in
                if value.isEmpty {
                    return "Please confirm your email."
                } else if value != self.email {
                    return "Emails do not match."
                }
                return nil
            }
        ]
        if let validate = validationRules[name] {
            let errorMessage = validate(value)
            switch name {
                case "firstName":
                    firstNameError = errorMessage
                case "lastName":
                    lastNameError = errorMessage
                case "email":
                    emailError = errorMessage
                case "confirmEmail":
                    confirmEmailError = errorMessage
                default:
                    break
            }
        }
    }
    func validateControls() -> Bool {
        return firstNameError == nil &&
        lastNameError == nil &&
        emailError == nil &&
        confirmEmailError == nil &&
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !confirmEmail.isEmpty
    }
}
