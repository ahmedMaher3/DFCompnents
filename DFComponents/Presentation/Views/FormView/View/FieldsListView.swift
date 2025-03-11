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
            EmptyView()

            case .textBox((_, let textBoxViewModel)):
            EmptyView()
            case .number((_, let numberViewModel)):
            BaseFieldContainerView(
                    fieldEntity: field,
                    controlType: {
                        NumberFieldComponent(viewModel: numberViewModel)
                            .onReceive(numberViewModel.objectWillChange) { updatedValue in
                                viewModel.checkingWarning(for: field.id,
                                                          value: "\(numberViewModel.inputValue)",
                                                          isError: numberViewModel.numberFieldModel.isError ?? false)
                            }
                    },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                        set: { newValue in
                            viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
                            ? [newValue!] : nil
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
