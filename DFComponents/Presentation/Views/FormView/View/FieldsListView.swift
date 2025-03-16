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
            BaseFieldContainerView(
                fieldEntity: field, controlType: { RadioButtonView(radioButtonVM: radioViewModel) },
                warningMessage: Binding<String?>(
                    get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                    set: { newValue in
                        viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
                        ? [newValue!] : nil
                    }
                ))
                .opacity(radioViewModel.control.hidden ? 0 : 1)

            case .textBox((_, let textBoxViewModel)):
            BaseFieldContainerView(
                fieldEntity: field, controlType: { TextBoxComponent(viewModel: textBoxViewModel) },
                warningMessage: Binding<String?>(
                    get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                    set: { newValue in
                        viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
                        ? [newValue!] : nil
                    }
                ))
                .opacity(textBoxViewModel.control.hidden ? 0 : 1)
            case .number((_, let numberViewModel)):
            BaseFieldContainerView(
                    fieldEntity: field,
                    controlType: {
                        NumberFieldComponent(viewModel: numberViewModel)
                    },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsDictionary[field.id]?.joined(separator: "\n") },
                        set: { newValue in
                            if let newValue = newValue, !newValue.isEmpty {
                                viewModel.warningsDictionary[field.id] = [newValue]
                            } else {
                                viewModel.warningsDictionary[field.id] = nil
                            }
                        }
                    )
                )
        case .page((_, _)):
            EmptyView()
        case .section((_, let sectionViewModel)):
            EmptyView()
//            SectionView(fields: sectionViewModel.controls)
        }
    }
}
