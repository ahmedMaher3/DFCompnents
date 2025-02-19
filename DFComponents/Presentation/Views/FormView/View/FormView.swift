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
                if !viewModel.formFields.isEmpty {
                    Form {
                        ForEach(viewModel.formFields , id: \.id) { field in
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
            .environmentObject(viewModel.rulesViewModel)
        }
    }
    
    // This function handles rendering the appropriate form control based on the field type
    @ViewBuilder
    private func renderField(for field: FormField) -> some View {
        switch field.type {
        case .DateTime:
            ControlFormBuilderView(titleControl: field.properties?.label ?? "Date Picker") {
                DateTimeView(viewModel: viewModel.dateFieldViewModel)
            }
        case .Checkbox:
            ControlFormBuilderView(titleControl: field.properties?.label ?? "Checkbox") {
                //                CheckBoxView(viewModel: viewModel.checkBoxViewModel)
            }
        case .Radio:
            ControlFormBuilderView(titleControl: field.properties?.label ?? "Radio Button") {
                //                RadioButtonView(viewModel: viewModel.radioButtonViewModel)
            }
        case .TextBox:
            ControlFormBuilderView(titleControl: field.properties?.label ?? "Text Box") {
                TextBoxComponent(viewModel: viewModel.textBoxViewModel)
            }
        case .DropDown:
            ControlFormBuilderView(titleControl: field.properties?.label ?? "Drop Down") {
                DropDownView(title: viewModel.dropdownViewModel.selectedCountry?.name ?? "Select Country", viewModel: viewModel.dropdownViewModel)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal)
            }
        default:
            Text("Unsupported field type")
                .foregroundColor(.red)
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
