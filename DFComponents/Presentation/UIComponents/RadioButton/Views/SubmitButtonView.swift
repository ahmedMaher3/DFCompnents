//
//  SubmitButtonView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct SubmitButtonView: View {
    @StateObject var radioButtonState: RadioButtonViewModel
    var body: some View {
        Button(action: {
            radioButtonState.validate()
            if radioButtonState.validationErrors.values.contains(where: { $0.isEmpty == false }) {
                print("Validation failed: Please answer all questions.")
            } else {
                print("Form submitted successfully!")
                // Handle form submission here
            }
        }) {
            Text("Submit")
                .fontWeight(.bold)
                .padding()
                .frame(width: 100, height: 50)
        }
        .padding(.top, 8)
    }
}
