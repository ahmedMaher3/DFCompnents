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
                        ForEach(viewModel.formFields, id: \.id) { field in
                            // Dynamically resolve and render view model for each field
                            if let viewModel = viewModel.viewModels[field.id] {
                                switch field.type.rawValue {
                                case "Radio":
                                        ControlFormBuilderView(titleControl: field.label) {
                                            let vm = viewModel as! RadioButtonViewModel
                                            QuestionsRadioButton(radioButtonVM: vm)
                                        }
                                    case "TextBox":
                                            EmptyView()
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

                FooterFormView()
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

