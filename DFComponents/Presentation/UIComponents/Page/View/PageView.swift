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
        
        if self.viewModel.mode == .classic {
            List {
                ForEach(controls, id: \.id) { field in
                    renderField(for: field)
                        .environmentObject(viewModel)
                }
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it fills space
        } else {
            
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Spacer()
                        ForEach(controls, id: \.id) { field in
                            renderField(for: field)
                                .frame(maxWidth: .infinity)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height) // Uses container height
                }
            }
            
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
                            viewModel.checkingWarning(for: field.id,
                                                      value: "\(numberViewModel.inputValue)",
                                                      isError: numberViewModel.numberFieldModel.isError ?? false)
                        }
                },
                footerView: {
                    FooterComponentView(viewModel: FooterComponentViewModel(fieldEntity: field,  interactiveProperties: numberViewModel.numberFieldModel.base))
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
            //                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity) // Ensure it's visible
        }
    }
    
}
