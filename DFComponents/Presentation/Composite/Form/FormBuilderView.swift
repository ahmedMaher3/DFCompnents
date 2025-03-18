//
//  FormBuilderView.swift
//  DFComponents
//
//  Created by Eslam on 16/03/2025.
//
import SwiftUI

struct FormBuilderView: FormComponent {

    var id = UUID().uuidString  // Unique identifier

    @ObservedObject var viewModel: FormViewModel
    @ObservedObject var stepProgressViewModel: StepProgressViewModel
    @ObservedObject var styleManagerVM: StyleManagerViewModel
    @Binding var currentLocale: Locale
    @Binding var showingAppearanceSheet: Bool
    @Binding var currentPage: Int
    @Environment(\.locale) private var locale

    var title: String = "FormView"

    // MARK: - FormComponent Protocol Implementation
    @ViewBuilder
    func render() -> some View {
        NavigationStack {
            VStack {
                if !viewModel.pages.isEmpty {
                    StepProgressView(viewModel: stepProgressViewModel)
                    Spacer()
                    TabView(selection: $currentPage) {
                        ForEach(viewModel.pages.indices, id: \.self) { index in
                            PageCompositeView(pageViewModel: PageViewModel(controls: viewModel.pages[index].fields), id: id)
                                .environmentObject(viewModel)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: self.viewModel.mode == .card ? .always : .never))
                    .onChange(of: currentPage) { oldValue, newPage in
                        stepProgressViewModel.updateCurrentPage(newPage)
                        stepProgressViewModel.updateProgress()
                    }
                    .if(self.viewModel.mode == .card) { tab in
                        tab.frame(height: UIScreen.main.bounds.height / 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .shadow(radius: 5)
                            )
                            .padding()
                    }
                    .if(self.viewModel.mode == .classic) { tab in
                        tab.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    Spacer()
                    FooterView(currentPage: $currentPage, totalPages: viewModel.pages.count)
                } else {
                    loadingView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#FAFBFF"))
            .navigationBarTitle(title, displayMode: .inline)
            .environmentObject(styleManagerVM)
            .onAppear {
                //                currentLocale = locale
                Task {
                    await viewModel.fetchForm()
                    updateStepProgress()
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func updateStepProgress() {
        stepProgressViewModel.totalPages = viewModel.pages.count
        stepProgressViewModel.updateProgress()
    }

    private func loadingView() -> some View {
        VStack {
            Text("Loading form data...")
                .padding()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}
