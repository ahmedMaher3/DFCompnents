//
//  ErrorMessageView.swift
//  DFComponents
//
//  Created by Eslam on 30/01/2025.
//

import SwiftUI

struct ErrorMessageView: View {
    @EnvironmentObject var styleManagerVM: StyleManagerViewModel

    let errorMessage: String
    let imageName: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(errorMessage)
                .font(styleManagerVM.styleManager.subtitleFont)
        }
        .foregroundStyle(styleManagerVM.styleManager.errorColor)
//        .color(.red)
        .padding(.top, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
