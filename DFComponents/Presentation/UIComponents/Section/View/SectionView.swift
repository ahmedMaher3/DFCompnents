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
    
//    @ViewBuilder
//    private func renderField(for field: FieldEntity) -> some View {
//        switch field {
//        case .radio ((_, let radioViewModel)):
//            ControlFormBuilderView<<#Header: View#>, <#Control: View#>, <#Footer: View#>>(titleControl: radioViewModel.control.label) {
//                RadioButtonView(radioButtonVM: radioViewModel)
//            }
//            .opacity(radioViewModel.control.hidden ? 0 : 1)
//            .onReceive(
//                radioViewModel.$control
//                    .map { $0.options }
//                    .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
//                    .dropFirst()
//                    .removeDuplicates()
//            ) { newOptions in
//                print("Updated options: \(newOptions)")
//
//            }
//        case .textBox((_, let textBoxViewModel)):
//            ControlFormBuilderView(titleControl: textBoxViewModel.control.label ) {
//                TextBoxComponent(viewModel: textBoxViewModel)
//            }
//            .opacity(textBoxViewModel.control.hidden ? 0 : 1)
//        case .page((_, _)):
//            EmptyView()
//        case .section((_, let sectionViewModel)):
//            SectionView(title: sectionViewModel.title, fields: sectionViewModel.controls)
//
//        }
//    }
    

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
    SectionView(title: "", fields: [])
}
