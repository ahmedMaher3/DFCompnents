//
//  fieldsListView.swift
//  DFComponents
//
//  Created by Eslam on 05/03/2025.
//
import SwiftUI
struct FieldsListView: View {
    @ObservedObject var viewModel: FormViewModel

    var body: some View {
        ForEach(viewModel.fields, id: \.id) { field in
            renderField(for: field)
        }
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
                        get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                        set: { newValue in
                            viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
                            ? [newValue!] : nil
                        }
                    ))
                .onAppear {
                    viewModel.checkingWarning(for: field.id, value: nil, isError: false)
                }
                .opacity(radioViewModel.control.hidden ? 0 : 1)

            case .textBox((_, let textBoxViewModel)):
                ControlFormBuilderView(
                    headerView: { EmptyView() },
                    controlType: {
                        TextBoxComponent(viewModel: textBoxViewModel)
                    },
                    footerView: { EmptyView() },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                        set: { newValue in
                            viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
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
                            .onReceive(numberViewModel.objectWillChange) { updatedValue in
                                viewModel.checkingWarning(for: field.id, value: "\(numberViewModel.inputValue)", isError: numberViewModel.numberFieldModel.isError ?? false)
                            }
                    },
                    footerView: {
                        FooterComponentView(viewModel: FooterComponentViewModel(interactiveProperties: numberViewModel.numberFieldModel.base))
                    },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                        set: { newValue in
                            viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
                            ? [newValue!] : nil
                        }
                    )
                )
        }
    }
}
