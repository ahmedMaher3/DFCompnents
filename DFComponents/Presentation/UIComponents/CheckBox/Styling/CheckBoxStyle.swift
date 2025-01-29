//
//  CheckBoxStyle.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI
struct CheckBoxStyle: ToggleStyle {
    let questionID: String  // The unique identifier for the question
    let item: CheckBoxModel  // The checkbox item to be displayed

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .color(configuration.isOn ? .primaryBlue : .primaryGray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
                .padding(.trailing, 8)

            configuration.label
                .color(configuration.isOn ? .primaryBlue : .customColor(.black))
                .fontWeight(.medium)
        }
    }
}
