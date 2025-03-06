//
//  RadioButtonView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct RadioButtonView: View {

    @ObservedObject var radioButtonVM: RadioButtonViewModel
    @EnvironmentObject var formViewModel: FormViewModel

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(radioButtonVM.control.options, id: \.id) { item in
                HStack {
                    Image(systemName:
                            item.isSelected ?? false ? "largecircle.fill.circle" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(item.isSelected ?? false ? .blue : .gray)
                    .onTapGesture {

                       radioButtonVM.selectOption(item)
                        formViewModel.updateTextBoxValue(fieldId: "91975fe4-40cc-4a4b-9c81-3eb0bed3ddb5", newValue: radioButtonVM.selectedValue)
                    }
                    Text(item.name)
                        .fontWeight(.medium)
                        .foregroundColor(item.isSelected ?? false ? .blue : .black)
                }
                .padding(8)
            }
        }
    }
}
