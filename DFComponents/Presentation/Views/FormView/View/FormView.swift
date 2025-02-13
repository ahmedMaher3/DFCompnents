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

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Rules Controls") {
                        RulesControlsView()
                    }
                    Section("Without Rules") {
                        ControlFormBuilderView(titleControl: "Date Range Picker") {
                            DateRangePickerView()
                        }
                        ControlFormBuilderView(titleControl: "Signature") {
                            SignatureView(viewModel: viewModel.signatureViewModel)
                        }
                        ControlFormBuilderView(titleControl: "Image Picker") {
                            ImagePickerView()
                        }
                        ControlFormBuilderView(titleControl: "Camera Picker") {
                            CameraPickerView()
                        }
                        ControlFormBuilderView(titleControl: "File Picker") {
                            FilePickerView()
                        }
                        ControlFormBuilderView(titleControl: "Slider") {
                            SliderView(viewModel: viewModel.sliderViewModel)
                        }
                        //MARK: - There issue when the Map appears after the user scrolls in the form 

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
                }
                .padding(.top, 10)
                .listRowSeparator(.hidden)
                .listStyle(PlainListStyle())
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear)

                // Buttons at the bottom
                //MARK: - This Footer work only with controls consider as rules
                FooterFormView()
            }
        }
        .navigationTitle(title)
        .environmentObject(styleManagerVM)
        .environmentObject(viewModel.rulesViewModel)
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
