//
//  PageView.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import SwiftUI

struct PageView: View {
    var controls: [FieldEntity]
    @EnvironmentObject var viewModel: FormViewModel

    var body: some View {
        VStack(spacing: 20) {
            ForEach(controls, id: \.id) { field in
                renderField(for: field)
                    .environmentObject(viewModel)
            }
        }
        .padding()
    }

    /// Controls
    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {
        switch field {
            case .radio((_, let radioViewModel)):
                ControlFormBuilderView(
                    headerView: { EmptyView() },
                    controlType: { RadioButtonView(radioButtonVM: radioViewModel) },
                    footerView: { EmptyView() },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsMessagesDictionary?[field.id]?.joined(separator: "") },
                        set: { newValue in
                            viewModel.warningsMessagesDictionary?[field.id] = newValue?.isEmpty == false
                            ? [newValue!] : nil
                        }
                    ))
                //                .onAppear {
                //                    viewModel.checkingWarning(for: field.id, value: nil)
                //                }
                .opacity(radioViewModel.control.hidden ? 0 : 1)

            case .textBox((_, let textBoxViewModel)):
                ControlFormBuilderView(
                    headerView: { EmptyView() },
                    controlType: {
                        TextBoxComponent(viewModel: textBoxViewModel)
                    },
                    footerView: { EmptyView() },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsMessagesDictionary?[field.id]?.joined(separator: "") },
                        set: { newValue in
                            viewModel.warningsMessagesDictionary?[field.id] = newValue?.isEmpty == false
                            ? [newValue!] : nil
                        }
                    )
                )
                .opacity(textBoxViewModel.control.hidden ? 0 : 1)

            case .number((_, let numberViewModel)):
                ControlFormBuilderView(
                    headerView: {
                        HeaderComponentView(viewModel: HeaderComponentViewModel(baseProperties: numberViewModel.numberFieldModel.basePropertiesNotInteractive))
                    },
                    controlType: {
                        NumberFieldComponent(viewModel: numberViewModel)
                            .onReceive(numberViewModel.$warningsMessagesDictionary) { newValue in
                                Task { @MainActor in
                                    viewModel.warningsMessagesDictionary = newValue
                                }
                            }
                    },
                    footerView: {
                        FooterComponentView(viewModel: FooterComponentViewModel(fieldEntity: field,  interactiveProperties: numberViewModel.numberFieldModel.base))
                    },
                    warningMessage: Binding<String?>(
                        get: {
                            return viewModel.warningsMessagesDictionary?[field.id]?.joined(separator: "\n")
                        },
                        set: { newValue in
                            if let newValue = newValue, !newValue.isEmpty {
                                viewModel.warningsMessagesDictionary?[field.id] = [newValue]
                            } else {
                                viewModel.warningsMessagesDictionary?[field.id] = nil
                            }
                        }
                    )
                )
            case .page((_, _)):
                EmptyView()
            case .section((_, let sectionViewModel)):
                SectionView(title: sectionViewModel.title, fields: sectionViewModel.controls)
        }
    }
}
