//
//  FormView.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

struct FormView: View {
    @StateObject var viewModel: FormViewModel = FormViewModel()
    @StateObject private var styleManagerVM = StyleManagerViewModel()

    @State private var showingAppearanceSheet = false

    var title: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Controls") {
                        ForEach(viewModel.controls, id: \.fieldId) {
                            field in
                            if let viewModel = viewModel.viewModels[field.fieldId] {
                                switch field.type.rawValue {
                                    case FieldType.TextBox.rawValue:
                                        ControlFormBuilderView(titleControl: field.label) {
                                            let vm = viewModel as! TextBoxViewModel
                                            TextBoxComponent(viewModel: vm)
                                        }
                                    default:
                                        EmptyView()
                                }
                            }
                        }
                    }
                }
                .padding(.top, 10)
                .listRowSeparator(.hidden)
                .listStyle(PlainListStyle())
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear)


                Button("Show Appearance Sheet") {
                    showingAppearanceSheet.toggle()
                }
                .sheet(isPresented: $showingAppearanceSheet) {
                    AppearanceSheetView()
                }
                Button {
                    //MARK: - Approach 
                    /*
                     key will be fieldId so
                     viewModels[fieldId] = TextBoxViewModel
                     viewModels[fieldId] = RadioButtonViewModel
                     viewModels[fieldId] = DropDownViewModel
                     and so on.....
                     */
                    viewModel.viewModels.forEach { (key: String, viewModel) in
                        if let textBoxVM = viewModel as? TextBoxViewModel {
                            self.viewModel.updateControlByViewModel(controlId: key)
                            print("Display the key:\(key)")
                           print("Answer:\(textBoxVM.textBoxField?.answer) and text base please:\(textBoxVM.textBoxField?.textBase) and text:\(textBoxVM.text)")
                        }
                    }
                    print(viewModel)
                } label: {
                    Text("Submit")
                }
//                FooterFormView()
            }
        }
        .navigationTitle(title)
        .environmentObject(viewModel)
        .environmentObject(styleManagerVM)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            APIService.fetchStyles { apiResponse in
                if let apiResponse = apiResponse {
                    styleManagerVM.updateStyles(from: apiResponse)
                }
            }
            viewModel.fetchForm()
        }
    }
}

