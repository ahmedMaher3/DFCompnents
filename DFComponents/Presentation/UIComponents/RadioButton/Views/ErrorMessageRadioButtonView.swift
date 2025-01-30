//
//  ErrorMessageView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct ErrorMessageRadioButtonView: View {
    let errorMessage: String

    var body: some View {
        HStack {
            Image(systemName: "xmark.circle.fill")
            Text(errorMessage)
                .font(.subheadline)
        }
        .color(.customColor(.red))
        .padding(.top, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
