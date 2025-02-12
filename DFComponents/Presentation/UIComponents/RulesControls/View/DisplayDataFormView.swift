//
//  DisplayDataFormView.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

import SwiftUI

struct DisplayDataFormView: View {
    @ObservedObject var viewModel: RulesControlsViewModel

    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("First Name: \(viewModel.firstName)")
                Text("Last Name: \(viewModel.lastName)")
                Text("Full Name: \(viewModel.fullName)")
                Text("Email: \(viewModel.email)")
                Text("Confirm Email: \(viewModel.confirmEmail)")

            }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

#Preview {
    DisplayDataFormView(viewModel: RulesControlsViewModel())
}
