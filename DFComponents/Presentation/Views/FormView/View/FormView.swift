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
                if !viewModel.fields.isEmpty {
                    Form {
                        ForEach(viewModel.fields , id: \.id) { field in
                            renderField(for: field)
                        }
                    }
                    .padding()
                } else {
                    // Show loading state while form data is being fetched
                    loadingView()
                        .onAppear {
                            Task {
                                await viewModel.fetchForm()
                            }
                        }
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
            .environmentObject(styleManagerVM)
            //   .environmentObject(viewModel.rulesViewModel)
        }
    }

    // This function handles rendering the appropriate form control based on the field type
    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {

        switch field {
        case .radio ((_, let radioViewModel)):
            ControlFormBuilderView(titleControl: radioViewModel.control.label) {
                RadioButtonView(radioButtonVM: radioViewModel)
            }
            .onReceive(
                radioViewModel.$control
                    .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
                    .dropFirst()
//                    .removeDuplicates()
            ) { newOptions in
                print("Updated options: \(newOptions.options)")
                // call update in viewmodel to notify change and apply rules
                viewModel.applyFieldRules(by: "cf6c2b5c-3dec-4222-9ceb-ac958c5bb24f")
            }

        case .textBox((_, let textBoxViewModel)):
            ControlFormBuilderView(titleControl: textBoxViewModel.control.label ) {
                TextBoxComponent(viewModel: textBoxViewModel)
            }
        }
    }


    // Loading view to be displayed while fetching the form data
    private func loadingView() -> some View {
        VStack {
            Text("Loading form data...")
                .padding()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}
