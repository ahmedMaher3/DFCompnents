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
    var fields: [FieldEntity]
    
    @State private var isExpanded: Bool = false
        
    init(sectionViewModel: SectionViewModel, fields: [FieldEntity], isExpanded: Bool) {
        self.sectionViewModel = sectionViewModel
        self.fields = sectionViewModel.controls
        self.isExpanded = isExpanded
    }
    
    var body: some View {
        Section(header: sectionHeader().frame(height: 70)) {
            if isExpanded {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(self.sectionViewModel.controls, id: \.id) { field in
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
                self.sectionViewModel.sectionField.isExpandedStatus = isExpanded
            }) {
                HStack {
                    
                    if let iconURLString = self.sectionViewModel.sectionField.icon, let iconURL = URL(string: iconURLString) {
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
                    Text(sectionViewModel.sectionField.label)
                        .font(.headline)
                        .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(isExpanded ? Color(hex: "#5989EF") : Color(hex: "#E6EDFD"))
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
                viewModel.checkingWarning(for: field.id, value: nil)
            }
            .onReceive(radioViewModel.$control) { _ in
                self.sectionViewModel.controls[0].value = radioViewModel.control.defaultAnswer?.value?.first
            }
            .opacity(radioViewModel.control.hidden ? 0 : 1)
            
        case .textBox((_, let textBoxViewModel)):
            BaseFieldContainerView(
                fieldEntity: field, controlType: {TextBoxComponent(viewModel: textBoxViewModel) },
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
                fieldEntity: field, controlType: {NumberFieldComponent(viewModel: numberViewModel) },
                warningMessage: Binding<String?>(
                    get: { viewModel.warningsDictionary[field.id]?.joined(separator: "") },
                    set: { newValue in
                        viewModel.warningsDictionary[field.id] = newValue?.isEmpty == false
                        ? [newValue!] : nil
                    }
                ))
        case .page((_, _)):
            EmptyView()
        case .section((_, _)):
            EmptyView()
        }
    }
}
