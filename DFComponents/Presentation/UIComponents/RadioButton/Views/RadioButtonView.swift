//
//  RadioButtonView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct RadioButtonView: View {

    @ObservedObject var radioButtonVM: RadioButtonViewModel

    var body: some View {
        Button {
            //MARK: - Action Button
            radioButtonVM.onTapRadioButton()
        } label: {
            HStack {
                Image(systemName:
                        radioButtonVM.selectedItem == radioButtonVM.itemValue
                      ? "largecircle.fill.circle"
                      : "circle"
                )
                .customizeImage(width: 24,
                                height: 24,
                                type: radioButtonVM.selectedItem == radioButtonVM.itemValue
                                ? .primaryBlue
                                : .primaryGray,
                                contentMode: .fit,
                                renderingMode: .original)


                Text(radioButtonVM.itemValue)
                    .color(.primaryBlue)
            }
        }
        .padding(8)
    }
}

#Preview {
    RadioButtonView(radioButtonVM: RadioButtonViewModel())
}
