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
        VStack(alignment: .leading) {
            ForEach(radioButtonVM.control.properties.options, id: \.id) { item in

                HStack {
                    Image(systemName:
                            item.isSelected ?? false ? "largecircle.fill.circle" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(item.isSelected ?? false ? .blue : .gray)
                    .onTapGesture {
                        radioButtonVM.selectOption(item)
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

