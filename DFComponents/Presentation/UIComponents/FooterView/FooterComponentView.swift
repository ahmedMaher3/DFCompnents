//
//  FooterComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//
import SwiftUI

struct FooterComponentView: View {
    @StateObject var viewModel: FooterComponentViewModel

    init(viewModel: FooterComponentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)

    }

    var body: some View {
        renderFooter(fieldEntity: viewModel.fieldEntity, for: viewModel.interactiveProperties)
            .padding(4)
    }

    /// FooterView
    @ViewBuilder
    private func renderFooter(fieldEntity: FieldEntity, for interactiveProperties: InteractiveField?) -> some View {

        switch fieldEntity {
            case .radio((_, let radioViewModel)): EmptyView()
            case .textBox((_, let textBoxViewModel)): EmptyView()
            case .number((let baseField, let numberViewModel)):
                if let interactiveProperties = interactiveProperties {

                    VStack {
                        HStack(alignment: .center, spacing: 4) {
                            if let tooltip = numberViewModel.numberFieldModel.tooltip {
                                Image(systemName: "info.circle.fill") // SF Symbol for tooltip icon
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            Text("\(numberViewModel.characterCount)/\(numberViewModel.numberFieldModel.maximumDigits ?? 0)")
                                .foregroundStyle(.gray)
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 4)
                        .padding(.trailing, 2)

                        if interactiveProperties.addNote || interactiveProperties.addAttachment {
                            HStack {
                                if interactiveProperties.addNote {
                                    Text("Note")
                                }
                                if interactiveProperties.addAttachment {
                                    Text("|| Attachment")
                                }
                            }
                        } else {
                            EmptyView()
                        }

                    }
                } else {
                    EmptyView()
                }
        }
    }
}
