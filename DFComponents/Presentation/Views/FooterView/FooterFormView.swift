//
//  SubmitView.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

import SwiftUI

struct FooterFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: RulesControlsViewModel
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            NavigationLink {
                DisplayDataFormView()
            } label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
//                    .background(viewModel.validateControls() ? .blue : .gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

#Preview {
    FooterFormView()
}
