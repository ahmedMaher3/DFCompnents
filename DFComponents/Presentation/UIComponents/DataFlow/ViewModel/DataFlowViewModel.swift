//
//  DataFlowViewModel.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

//class DataFlowViewModel: ObservableObject {
//    enum Field {
//        case firstName
//        case lastName
//    }
//    @Published var firstName = "" {
//        didSet {
//            validateInput(for: .firstName, value: firstName)
//        }
//    }
//    @Published var lastName = "" {
//        didSet {
//            validateInput(for: .lastName, value: lastName)
//        }
//    }
//    @Published var firstNameError: String? = nil
//    @Published var lastNameError: String? = nil
//    var fullName: String {
//        if firstNameError != nil || lastNameError != nil {
//            return ""
//        }
//        return firstName + " " + lastName
//    }
//
//    func validateInput(for field: Field, value: String) {
//        if value.contains(" ") {
//            // If there's more than one word, show the error
//            if field == .firstName {
//                firstNameError = "First name must be one word."
//            } else if field == .lastName {
//                lastNameError = "Last name must be one word."
//            }
//        } else {
//            // If there's only one word, remove the error
//            if field == .firstName {
//                firstNameError = nil
//            } else if field == .lastName {
//                lastNameError = nil
//            }
//        }
//    }
//
//}
import SwiftUI


class DataFlowViewModel: ObservableObject {
    @Published var firstName = "" {
        didSet {
            validateInput(for: "firstName", value: firstName)
        }
    }

    @Published var lastName = "" {
        didSet {
            validateInput(for: "lastName", value: lastName)
        }
    }

    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil

    // Full name will be empty if there's an error in either first name or last name
    var fullName: String {
        if firstNameError != nil || lastNameError != nil {
            return ""  // Full name is empty if there's an error
        }
        return firstName + " " + lastName
    }

    // Validation function to check for one word only
    func validateInput(for field: String, value: String) {
        if value.contains(" ") {
            // If more than one word, set error
            if field == "firstName" {
                firstNameError = "First name must be one word."
            } else if field == "lastName" {
                lastNameError = "Last name must be one word."
            }
        } else {
            // If valid, remove the error
            if field == "firstName" {
                firstNameError = nil
            } else if field == "lastName" {
                lastNameError = nil
            }
        }
    }
}
