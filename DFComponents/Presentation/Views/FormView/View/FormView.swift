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

    var title: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            List {
                ControlFormBuilderView(titleControl: "Date Range Picker") {
                    DateRangePickerView()
                }
                ControlFormBuilderView(titleControl: "Signature") {
                    SignatureView(viewModel: viewModel.signatureViewModel)
                }
                ControlFormBuilderView(titleControl: "Image Picker") {
                    ImagePickerView()
                }
                ControlFormBuilderView(titleControl: "File Picker") {
                    FilePickerView()
                }
                ControlFormBuilderView(titleControl: "Slider") {
                    SliderView(viewModel: viewModel.sliderViewModel)
                }
                ControlFormBuilderView(titleControl: "Map") {
                    MapView()
                        .frame(height: 200)
                }
                ControlFormBuilderView(titleControl: "Section") {
                    SectionView()
                        .frame(height: 300)
                }
                ControlFormBuilderView(titleControl: "Drop Down") {
                    DropDownView(title: viewModel.dropdownViewModel.selectedCountry?.name ?? "Select Country", viewModel: viewModel.dropdownViewModel)
                        .listRowSeparator(.hidden)
                        .padding(.horizontal)
                }
                ControlFormBuilderView(titleControl: "Text Box") {
                    TextBoxComponent(viewModel: viewModel.textBoxViewModel)
                }
                ControlFormBuilderView(titleControl: "Date Picker") {
                    DateTimeView(viewModel: viewModel.dateFieldViewModel)
                }
                ControlFormBuilderView(titleControl: "Radio Button") {
                    QuestionsRadioButton(radioButtonVM: viewModel.radioButtonViewModel)
                }
                ControlFormBuilderView(titleControl: "CheckBox") {
                    MultiChoiceQuestion(checkBoxVM: viewModel.checkBoxViewModel)
                }
            }
            .padding(.top, 10)
            .listRowSeparator(.hidden)
            .listStyle(PlainListStyle())
            .buttonStyle(PlainButtonStyle())
            .listRowBackground(Color.clear)

            // Buttons at the bottom
            HStack(spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Submit action
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .navigationTitle(title)
        .environmentObject(styleManagerVM)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            APIService.fetchStyles { apiResponse in
                if let apiResponse = apiResponse {
                    styleManagerVM.updateStyles(from: apiResponse)
                }
            }
        }
    }
}

#Preview {
    FormView(viewModel: FormViewModel(), title: "Form Title")
}
