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
        }) {
            Text("Submit")
                .fontWeight(.bold)
                .padding()
                .frame(width: 100, height: 50)
        }
        .padding(.top, 8)
    }
}
