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
        renderHeader(for: viewModel.baseProperties)
    }

    /// HeaderView
    @ViewBuilder
    private func renderHeader(for baseProperties: BaseProperties?) -> some View {
        if let _ = baseProperties {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                if let label = viewModel.baseProperties.label {
                    labelView(label: label, baseProperties: viewModel.baseProperties)
                }
                if let subLabel = viewModel.baseProperties.sublabel {
                    Text(subLabel)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }

            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        } else {
            EmptyView() // If no header is available
        }
    }
    ///Label
    @ViewBuilder
    private func labelView(label: String, baseProperties: BaseProperties) -> some View {
        if baseProperties.required ?? false {
            HStack(alignment: .center) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("* ")
                    .foregroundStyle(.red)
            }
        } else {
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}
