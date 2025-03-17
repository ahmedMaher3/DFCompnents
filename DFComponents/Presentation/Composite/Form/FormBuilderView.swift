//
//  FormBuilderView.swift
//  DFComponents
//
//  Created by Eslam on 16/03/2025.
//
import SwiftUI
/*
struct FormBuilderWrapperView: View {
    @StateObject private var viewModel = FormViewModel()
    @StateObject private var stepProgressViewModel = StepProgressViewModel()
    @StateObject private var styleManagerVM = StyleManagerViewModel()
    @State private var currentLocale: Locale = .current
    @State private var showingAppearanceSheet = false
    @State private var currentPage: Int = 0
    var body: some View {
        FormBuilderView(
            id: UUID().uuidString,
            stepProgressViewModel: stepProgressViewModel,
            styleManagerVM: styleManagerVM,
            currentLocale: $currentLocale,
            showingAppearanceSheet: $showingAppearanceSheet,
            currentPage: $currentPage
        ).render()
    }
}
*/

struct FormBuilderView: FormComponent {
    var id = UUID().uuidString  // Unique identifier
    @StateObject private var viewModel = FormViewModel()
    @StateObject private var stepProgressViewModel = StepProgressViewModel()
    @StateObject private var styleManagerVM = StyleManagerViewModel()
    @State private var currentLocale: Locale = .current
    @State private var showingAppearanceSheet = false
    @State private var currentPage: Int = 0

    @Environment(\.locale) private var locale
    var title: String = "FormView"



    var body: some View {
        render()
    }

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
                    //                    await viewModel.fetchForm()
                    updateStepProgress()
                    //                    viewModel.warnings.map { entity in
                    //                        print(entity)
                    //                    }
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
