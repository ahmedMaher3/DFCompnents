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
            case .page((_, _)): EmptyView()
            case .section((_, _)): EmptyView()
            case .radio((_, let radioViewModel)): EmptyView()
            case .textBox((_, let textBoxViewModel)): EmptyView()
            case .number((_, let numberViewModel)):
                if let interactiveProperties = interactiveProperties {
                    VStack {
                        Text("\(numberViewModel.characterCount)/\(numberViewModel.numberFieldModel.maximumDigits ?? 0)")
                            .foregroundStyle(.gray)
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding([.top,.trailing], 4)
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
