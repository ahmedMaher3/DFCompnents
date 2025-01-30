//
//  RadioButtonView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct RadioButtonView: View {
    @StateObject var radioButtonState: RadioButtonViewModel
    let questionID: String
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(radioButtonState.radioButtonModels[questionID] ?? [], id: \.id) { item in
                Button {
                    radioButtonState.onTapRadioButton(questionID: questionID, item: item)
                } label: {
                    HStack {
                        Image(systemName:
                                radioButtonState.selectedItem(for: questionID)?.id == item.id
                              ? "largecircle.fill.circle"
                              : "circle")
                        .customizeImage(width: 24, height: 24,
                                        type: radioButtonState.selectedItem(
                                            for: questionID)?.id == item.id ? .primaryBlue : .primaryGray,contentMode: .fit,  renderingMode: .original)

                        Text(item.name)
                            .fontWeight(.medium)
                            .color(radioButtonState.selectedItem(for: questionID)?.id == item.id ? .primaryBlue : .black)
                    }
                }
                .padding(8)
            }
        }
    }
}

