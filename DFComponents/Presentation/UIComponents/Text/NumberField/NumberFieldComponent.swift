//
//  NumberFieldComponent.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct NumberFieldComponent: View {
    @StateObject var viewModel: NumberFieldViewModel
    init(viewModel: NumberFieldViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ///HeaderView
        ///Content Control
        VStack {
            Text("Stepper Value\(viewModel.numberFieldModel.step ?? 0)")
            Text("Decimal Value\(viewModel.numberFieldModel.decimalPlaces ?? 0)")
            Button {
                viewModel.numberFieldModel.step! += viewModel.numberFieldModel.step!
            } label: {
                Text("Increase Stepper")
            }
        }
        ///FooterView
    }
}
