//
//  SubmitControlView.swift
//  DFComponents
//
//  Created by Eslam on 30/01/2025.
//

import SwiftUI

struct SubmitButtonView<ViewModel: SubmitControlProtocol>: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        Button(action: {
            viewModel.validate()

        }) {
            Text("Submit")
                .fontWeight(.bold)
                .padding()
                .frame(width: 100, height: 50)
        }
        .padding(.top, 8)
    }
}
