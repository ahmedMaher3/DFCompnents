//
//  FormView.swift
//  DFComponents
//
//  Created by Ahmed Maher on 26/02/2025.
//

import SwiftUI

struct FormView: View {
    @StateObject private var viewModel = FormViewModel()
    @StateObject private var stepProgressViewModel = StepProgressViewModel()
    @StateObject private var styleManagerVM = StyleManagerViewModel()

    @State private var currentPage: Int = 0
    var title: String = "FormView"

    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "#FAFBFF"))
                .navigationBarTitle(title, displayMode: .inline)
                .environmentObject(styleManagerVM)

                .onAppear {
                    Task {
                        await viewModel.fetchForm()
                        updateStepProgress()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            LoadingView()
        case .error:
            EmptyView()
        case .loaded:
            FormContentView(
                viewModel: viewModel,
                stepProgressViewModel: stepProgressViewModel,
                currentPage: $currentPage
            )
        }
    }




    private func updateStepProgress() {
        stepProgressViewModel.totalPages = viewModel.pages.count
        stepProgressViewModel.updateProgress()
    }
}

// MARK: - Form Content View
private struct FormContentView: View {
    @ObservedObject var viewModel: FormViewModel
    @ObservedObject var stepProgressViewModel: StepProgressViewModel
    @Binding var currentPage: Int

    var body: some View {
        VStack {
            StepProgressView(viewModel: stepProgressViewModel)
            Spacer()
            TabView(selection: $currentPage) {
                ForEach(viewModel.pages.indices, id: \.self) { index in
                    PageView(pageViewModel: PageViewModel(controls: viewModel.pages[index].fields))
                        .environmentObject(viewModel)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: viewModel.mode == .card ? .always : .never))
            .onChange(of: currentPage) { oldpage,newPage in
                stepProgressViewModel.updateCurrentPage(newPage)
                stepProgressViewModel.updateProgress()
            }
            .frameModifier(for: viewModel.mode!)

            Spacer()
            PageFooterView(currentPage: $currentPage, totalPages: viewModel.pages.count)
        }
    }
}



