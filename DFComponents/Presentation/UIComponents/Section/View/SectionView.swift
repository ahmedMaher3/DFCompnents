//
//  SectionView.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import SwiftUI

struct SectionView: View {
    
    @ObservedObject var sectionViewModel: SectionViewModel
    @EnvironmentObject var viewModel: FormViewModel
//    var control: SectionField
//    let title: String
//    let icon: String
    let fields: [FieldEntity]
    
    @State private var isExpanded: Bool = false
    
//    init(fields: [FieldEntity], isExpanded: Bool) {
//        self.fields = fields
//        self.isExpanded = isExpanded
//    }
    
    init(sectionViewModel: SectionViewModel, fields: [FieldEntity], isExpanded: Bool) {
        self.sectionViewModel = sectionViewModel
        self.fields = fields
        self.isExpanded = isExpanded
    }
    
    
    var body: some View {
        Section(header: sectionHeader()) {
            if isExpanded {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        
                        ForEach(fields, id: \.id) { field in
                            renderField(for: field)
                        }
                    }
                }
            }
        }
        .listRowInsets(EdgeInsets())
    }
        
    // MARK: - Section Header
    @ViewBuilder
    private func sectionHeader() -> some View {
        VStack {
            Button(action: {
                isExpanded.toggle()
                self.sectionViewModel.control.isExpandedStatus = isExpanded
            }) {
                HStack {
                    
                    if let iconURLString = self.sectionViewModel.control.icon, let iconURL = URL(string: iconURLString) {
                        AsyncImage(url: iconURL) { image in
                            image.resizable()
                                 .scaledToFit()
                                 .frame(width: 24, height: 24)
                                 .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image("Business")
                            .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                    }
                    Text(sectionViewModel.control.label)
                        .font(.headline)
                        .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                }
                .padding()
                .background(isExpanded ? Color(hex: "#5989EF") : Color(hex: "#E6EDFD"))
            }
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
            EmptyView()
//            SectionView(viewModel: sectionViewModel.control, control: sectionViewModel.controls, title: sectionViewModel.control.label, icon: "")
        }
    }
}

//#Preview {
//    SectionView(title: "", fields: [])
//}
