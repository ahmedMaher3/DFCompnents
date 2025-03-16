//
//  PageView.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import SwiftUI

struct PageView: View {
    
    @EnvironmentObject var viewModel: FormViewModel
    @ObservedObject var pageViewModel: PageViewModel
    
    init(pageViewModel: PageViewModel) {
        self.pageViewModel = pageViewModel
    }
    
    var body: some View {
        
        if self.viewModel.mode == .classic {
            List {
                ForEach(self.pageViewModel.controls, id: \.id) { field in
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
                        ForEach(self.pageViewModel.controls, id: \.id) { field in
                            renderField(for: field)
                                .frame(maxWidth: .infinity)
                                .environmentObject(viewModel)
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
            BaseFieldContainerView(
                fieldEntity: field, controlType: {RadioButtonView(radioButtonVM: radioViewModel) },
                warningMessage: Binding<String?>(
                    get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                    set: { newValue in
                        viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
                        ? [newValue!] : nil
                    }
                ))
            .onAppear {
                viewModel.checkingWarning(for: field.id, value: nil)
            }
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
                fieldEntity: field, controlType: {  NumberFieldComponent(viewModel: numberViewModel) },
                warningMessage: Binding<String?>(
                    get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                    set: { newValue in
                        viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
                        ? [newValue!] : nil
                    }
                ))
        case .page((_, _)):
            EmptyView()
        case .section((_, let sectionViewModel)):
            SectionView(sectionViewModel: sectionViewModel, fields: sectionViewModel.controls, isExpanded: sectionViewModel.sectionField.isExpandedStatus)
                .onReceive(sectionViewModel.objectWillChange) { updatedValue in
                    print("updated Values:- \(sectionViewModel.controls)")
                }
        }
    }
    
}
