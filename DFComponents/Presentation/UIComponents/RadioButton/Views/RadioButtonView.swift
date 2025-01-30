//
//  RadioButtonView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct RadioButtonView: View {
    @StateObject var radioButtonVM: RadioButtonViewModel
    let questionID: String
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(radioButtonVM.radioButtonModels[questionID] ?? [], id: \.id) { item in
                Button {
                    radioButtonVM.onTapRadioButton(questionID: questionID, item: item)
                } label: {
                    HStack {
                        Image(systemName:
                                radioButtonVM.selectedItem(for: questionID)?.id == item.id
                              ? "largecircle.fill.circle"
                              : "circle")
                        .customizeImage(width: 24, height: 24,
                                        type: radioButtonVM.selectedItem(
                                            for: questionID)?.id == item.id ? .primaryBlue : .primaryGray,contentMode: .fit,  renderingMode: .original)

                        Text(item.name)
                            .fontWeight(.medium)
                            .color(radioButtonVM.selectedItem(for: questionID)?.id == item.id ? .primaryBlue : .black)
                    }
                }
                .padding(8)
            }
        }
    }
}

