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
            BaseFieldContainerView(
                    fieldEntity: field, controlType: { RadioButtonView(radioButtonVM: radioViewModel) },
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
            BaseFieldContainerView(
                    fieldEntity: field, controlType: {
                        TextBoxComponent(viewModel: textBoxViewModel)
                    },
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
            BaseFieldContainerView(
                    fieldEntity: field, controlType: {
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

struct PageVieww: View {
    var controls: [FieldEntity]

    @ObservedObject var viewModel: FormViewModel

    var body: some View {
        VStack {
            ForEach(controls, id: \.id) { field in
                renderField(for: field)
            }
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
                .onAppear {
                    viewModel.checkingWarning(for: field.id, value: nil, isError: false)
                }
                .opacity(radioViewModel.control.hidden ? 0 : 1)

            case .textBox((_, let textBoxViewModel)):
            BaseFieldContainerView(
                    fieldEntity: field, controlType: {
                        TextBoxComponent(viewModel: textBoxViewModel)
                    },
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
            BaseFieldContainerView(
                    fieldEntity: field, controlType: {
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

#Preview {
    PageView(controls: [])
}
