//
//  StepperNumberFieldView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct StepperNumberFieldView: View {
    @ObservedObject var viewModel: NumberFieldViewModel
    @FocusState.Binding var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            VStack(spacing: 3) {
                Image(systemName: "chevron.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.gray)
                    .onTapGesture {
                        viewModel.incrementStepper()
                        isTextFieldFocused = false
                    }
                Rectangle()
                    .frame(width: 12, height: 1)
                    .foregroundStyle(.gray)
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.gray)
                    .onTapGesture {
                        viewModel.decrementStepper()
                        isTextFieldFocused = false
                    }
            }
            .padding(.trailing, 10)
            .background(Color.clear)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
