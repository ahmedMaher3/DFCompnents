//
//  SectionView.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import SwiftUI

struct SectionView: View {
    
    @EnvironmentObject var viewModel: FormViewModel
    let title: String
//    let icon: String
    let fields: [FieldEntity]
    
    @State private var isExpanded = true
    
    var body: some View {
        List {
            Section(header: sectionHeader()) {
                if isExpanded {
                    ForEach(fields, id: \.id) { field in
                        renderField(for: field)
                    }
                }
            }
        }
        .listStyle(PlainListStyle()) // Native list styling
    }
    
    // MARK: - Section Header
    @ViewBuilder
    private func sectionHeader() -> some View {
        Button(action: { isExpanded.toggle() }) {
            HStack {
//                Image(systemName: icon)
//                    .foregroundColor(.white)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
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
                        get: { viewModel.warningsDictionary?[field.id]?.joined(separator: "") },
                        set: { newValue in
                            viewModel.warningsDictionary?[field.id] = newValue?.isEmpty == false
                            ? [newValue!] : nil
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
                        get: { viewModel.warningsDictionary?[field.id]?.joined(separator: "") },
                        set: { newValue in
                            viewModel.warningsDictionary?[field.id] = newValue?.isEmpty == false
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
                    },
                    footerView: {
                        FooterComponentView(viewModel: FooterComponentViewModel(fieldEntity: field,  interactiveProperties: numberViewModel.numberFieldModel.base))
                    },
                    warningMessage: Binding<String?>(
                        get: { viewModel.warningsDictionary?[field.id]?.joined(separator: "\n") },
                        set: { newValue in
                            if let newValue = newValue, !newValue.isEmpty {
                                viewModel.warningsDictionary?[field.id] = [newValue]
                            } else {
                                viewModel.warningsDictionary?[field.id] = nil
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

#Preview {
    SectionView(title: "", fields: [])
}
