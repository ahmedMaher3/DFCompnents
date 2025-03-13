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
                        get: { viewModel.warningsMessagesDictionary?[field.id]?.joined(separator: "\n") },
                        set: { newValue in
                            if let newValue = newValue, !newValue.isEmpty {
                                viewModel.warningsMessagesDictionary?[field.id] = [newValue]
                            } else {
                                viewModel.warningsMessagesDictionary?[field.id] = nil
                            }
                        }
                    ))
                .opacity(radioViewModel.control.hidden ? 0 : 1)

            case .textBox((_, let textBoxViewModel)):
                ControlFormBuilderView(
                    headerView: { EmptyView() },
                    controlType: {
                        TextBoxComponent(viewModel: textBoxViewModel)
                    },
                    footerView: { EmptyView() },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsMessagesDictionary?[field.id]?.joined(separator: "\n") },
                        set: { newValue in
                            if let newValue = newValue, !newValue.isEmpty {
                                viewModel.warningsMessagesDictionary?[field.id] = [newValue]
                            } else {
                                viewModel.warningsMessagesDictionary?[field.id] = nil
                            }
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
                    },
                    footerView: {
                        FooterComponentView(viewModel: FooterComponentViewModel(fieldEntity: field,  interactiveProperties: numberViewModel.numberFieldModel.base))
                    },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsMessagesDictionary?[field.id]?.joined(separator: "\n") },
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
