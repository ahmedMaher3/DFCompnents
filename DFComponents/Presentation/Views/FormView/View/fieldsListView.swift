//
//  fieldsListView.swift
//  DFComponents
//
//  Created by Eslam on 05/03/2025.
//
import SwiftUI
struct fieldsListView: View {
    @ObservedObject var viewModel: FormViewModel

    var body: some View {
        ForEach(viewModel.fields, id: \.id) { field in
            renderField(for: field)
        }
    }
    
    ///HeaderView
    @ViewBuilder
    private func renderHeader(for baseProperties: BaseProperties?) -> some View {
        if let baseProperties = baseProperties {
            HeaderComponentView(viewModel: HeaderComponentViewModel(baseProperties: baseProperties)) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    if let label = baseProperties.label {
                        labelView(label: label, baseProperties: baseProperties)
                    }
                    if let subLabel = baseProperties.subLabel {
                        Text(subLabel)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }
                    if let tooltip = baseProperties.tooltip {
                        HStack {
                            Text("ⓘ")
                                .font(.system(size: 18))
                                .foregroundStyle(.gray)

                            Text(tooltip)
                                .font(.system(size: 20))
                                .foregroundStyle(.gray)
                                .offset(y: 5)
                        }
                    }
                }
            }
            .padding(.bottom, 8)
        } else {
            EmptyView() // If no header is available
        }
    }
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
                .font(.headline)
                .foregroundColor(.primary)
        }
    }

    ///Controls
    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {
        switch field {
            case .radio((_, let radioViewModel)):
                ControlFormBuilderView {
                    EmptyView()
                } controlType: {
                    RadioButtonView(radioButtonVM: radioViewModel)
                } footerView: {
                    EmptyView()
                }
                .opacity(radioViewModel.control.hidden ? 0 : 1)

            case .textBox((_, let textBoxViewModel)):
                ControlFormBuilderView {
                    EmptyView()
                } controlType: {
                    TextBoxComponent(viewModel: textBoxViewModel)
                } footerView: {
                    EmptyView()
                }
                .opacity(textBoxViewModel.control.hidden ? 0 : 1)

            case .number((_, let numberViewModel)):
                ControlFormBuilderView {
                    renderHeader(for: numberViewModel.baseProperties)
                } controlType: {
                    NumberFieldComponent(viewModel: numberViewModel)
                } footerView: {
                    renderFooter(for: numberViewModel.numberFieldModel.base)
                }
        }
    }

    ///FooterView
    @ViewBuilder
    private func renderFooter(for interactiveProperties: InteractiveField?) -> some View {
        if let interactiveProperties = interactiveProperties {
            FooterComponentView(viewModel:
                                    FooterComponentViewModel(interactiveBaseProperties: interactiveProperties)) {
                HStack {
                    if interactiveProperties.addNote {
                        Text("Note")
                    }
                    if interactiveProperties.addAttachment {
                        Text("|| Attachment")
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}
