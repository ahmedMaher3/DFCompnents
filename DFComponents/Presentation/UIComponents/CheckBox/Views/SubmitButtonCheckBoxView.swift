//
//  SubmitButtonCheckBoxView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct SubmitButtonCheckBoxView: View {
    @StateObject var checkBoxState: CheckBoxViewModel
    var body: some View {
        Button(action: {
            checkBoxState.validate()
        }) {
            Text("Submit")
                .fontWeight(.bold)
                .padding()
                .frame(width: 100, height: 50)
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
