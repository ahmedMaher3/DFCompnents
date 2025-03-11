//
//  HeaderComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct HeaderComponentView: View {
    @StateObject var viewModel: HeaderComponentViewModel
    
    init(viewModel: HeaderComponentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        renderHeader(for: viewModel.field)
    }

    /// HeaderView
    @ViewBuilder
    private func renderHeader(for control: FieldEntity?) -> some View {
        if let fieldEntity = control {
            switch fieldEntity {
            case .page, .section, .radio, .textBox:
                EmptyView()
            case .number((_, let numberViewModel)):
                let properties = numberViewModel.numberFieldModel.basePropertiesNotInteractive
                labelView(baseProperties: properties)
            }
        }
    }
    ///Label
    @ViewBuilder
    private func labelView(baseProperties: BaseProperties) -> some View {
        if baseProperties.required ?? false {
            HStack(alignment: .center) {
                Text(baseProperties.label ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("* ")
                    .foregroundStyle(.red)
            }
        } else {
            Text(baseProperties.label ?? "")
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}
