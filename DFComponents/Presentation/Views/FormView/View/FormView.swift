//
//  FormView.swift
//  DFComponents
//
//  Created by Ahmed Maher on 26/02/2025.
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
                        FieldsListView(viewModel: viewModel)

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

struct FieldsListView: View {
    @ObservedObject var viewModel: FormViewModel  // ObservedObject prevents unnecessary re-renders

    var body: some View {
        ForEach(viewModel.fields, id: \.id) { field in
            renderField(for: field)

        }
    }

    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {

        switch field {
        case .radio ((_, let radioViewModel)):
            ControlFormBuilderView(titleControl: radioViewModel.control.label) {
                RadioButtonView(radioButtonVM: radioViewModel)
            }
            .opacity(radioViewModel.control.hidden ? 0 : 1)
            .onReceive(
                radioViewModel.$control
                    .map { $0.options }
                    .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
                    .dropFirst()
                    .removeDuplicates()
            ) { newOptions in
                print("Updated options: \(newOptions)")
                // Call update in ViewModel to apply rules
                viewModel.applyFieldRules(by: "cf6c2b5c-3dec-4222-9ceb-ac958c5bb24f")
            }


        case .textBox((_, let textBoxViewModel)):
            ControlFormBuilderView(titleControl: textBoxViewModel.control.label ) {
                TextBoxComponent(viewModel: textBoxViewModel)
            }
            .opacity(textBoxViewModel.control.hidden ? 0 : 1)
        }
    }


}
