//
//  NumberFieldComponent.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct NumberFieldComponent: View {
    @ObservedObject var viewModel: NumberFieldViewModel

    var body: some View {
        VStack {
            NumberFieldRenderStrategy()
                .render(field: .number((viewModel.numberFieldModel, viewModel)))
        }
    }
}
