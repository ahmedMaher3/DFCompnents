//
//  NumberFieldRenderStrategy.swift
//  DFComponents
//
//  Created by Eslam on 17/03/2025.
//
import SwiftUI

final class NumberFieldRenderStrategy: RenderStrategy {

    @ViewBuilder
    func render(field: FieldEntity) -> some View {
        if case .number((_, let numberViewModel)) = field {
            ZStack {
                InputNumberView(viewModel: numberViewModel)

                if let step = numberViewModel.numberFieldModel.step, step != 0 {
                    StepperNumberFieldView(viewModel: numberViewModel)
                }
            }
        } else {
            EmptyView()
        }
    }
}
