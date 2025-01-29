//
//  RadioButtonView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct RadioButtonView: View {

    @StateObject var radioButtonState: RadioButtonViewModel

    let item: RadioButtonModel
    let questionID: String  // Unique identifier for each question

    var body: some View {
        Button {
            radioButtonState.onTapRadioButton(questionID: questionID, item: item)
        } label: {
            HStack {
                Image(systemName:
                        radioButtonState.selectedItem(for: questionID)?.id == item.id
                      ? "largecircle.fill.circle"
                      : "circle")
                .customizeImage(width: 24,
                                height: 24,
                                type: radioButtonState.selectedItem(for: questionID)?.id == item.id ? .primaryBlue : .primaryGray,
                                contentMode: .fit,
                                renderingMode: .original)

                Text(item.name)
                    .fontWeight(.medium)
                    .color(radioButtonState.selectedItem(for: questionID)?.id == item.id ? .primaryBlue : .primaryGray)
            }
        }
        .padding(8)
    }
}

