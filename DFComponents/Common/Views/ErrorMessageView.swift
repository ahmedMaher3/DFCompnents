//
//  ErrorMessageView.swift
//  DFComponents
//
//  Created by Eslam on 30/01/2025.
//

import SwiftUI

struct ErrorMessageView: View {
    let errorMessage: String
    let imageName: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(errorMessage)
                .font(.subheadline)
        }
        .color(.red)
        .padding(.top, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
