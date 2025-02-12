//
//  FormFieldView.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

import SwiftUI

struct FormFieldView: View {
    @Binding var text: String
    @Binding var error: String?
    var placeholder: String
    var isValid: Bool
    var isEmailField: Bool = false
    var isEmailConfirmField: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(isEmailField ? .none : .words)
                .keyboardType(isEmailField || isEmailConfirmField ? .emailAddress : .default)
                .padding(.all, 8)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isValid ? Color.green : Color.gray, lineWidth: 1)
                        .padding(.horizontal, 1)
                }

            if let error = error {
                ErrorMessageView(errorMessage: error, imageName: "xmark.circle.fill")
            }
        }
    }
}
