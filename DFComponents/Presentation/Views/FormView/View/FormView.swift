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
    @StateObject private var router = Router()

    @State private var currentPage: Int = 0
    var title: String = "FormView"

    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "#FAFBFF"))
                .navigationBarTitle(title, displayMode: .inline)
                .environmentObject(styleManagerVM)
                .environmentObject(router)

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
    @ObservedObject private var router = Router()
    @State private var headerVisible = true
    @Binding var currentPage: Int

    private var shouldShowHeader: Bool {
        headerVisible &&
        viewModel.pages.first?.mode == .classic &&
        currentPage == viewModel.pages.indices.first
    }

    var body: some View {
        VStack {

            if let pageHeader = viewModel.header, shouldShowHeader {
                ClassicPageHeaderView(viewModel: ClassicPageHeaderViewModel(headerData: PageHeaderEntity(classicPageHeader: pageHeader)))
            }

            StepProgressView(viewModel: stepProgressViewModel)
            Spacer()
            TabView(selection: $currentPage) {
                ForEach(viewModel.pages.indices, id: \.self) { index in
                    PageView(pageViewModel: PageViewModel(
                        controls: viewModel.pages[index].fields,
                        showFooter: index == (viewModel.pages.indices.last ?? 0),
                        pageFooter: self.viewModel.footer!,
                        pageField: viewModel.pages[index].page
                    ), onScroll: { offset in
                        withAnimation {
                            self.headerVisible = offset > -50
                        }
                    },headerVisible: $headerVisible)
                    .environmentObject(viewModel)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: viewModel.mode == .card ? .always : .never))
            .onChange(of: currentPage) { oldPage, newPage in
                stepProgressViewModel.updateCurrentPage(newPage)
                stepProgressViewModel.updateProgress()
            }
            .frameModifier(for: viewModel.mode!)
            Spacer()
            
            handleFooter(pageField: self.viewModel.pages[currentPage].page)
        }
        .onAppear {
            if viewModel.mode == .card {
                if let welcomeCardData = viewModel.welcomeEntity {
                    router.present(.welcomeView(viewModel: WelcomeViewModel(welcomeEntity: welcomeCardData)))
                }
            }
        }
        .fullScreenCover(item: $router.presentedRoute) { route in
            router.destination(for: route)
        }
        .environmentObject(router)
    }
    
    private func handleFooter(pageField: PageField) -> PageFooterView {
        return PageFooterView(
            currentPage: $currentPage,
            totalPages: viewModel.pages.count,
            pageProperties: PageProperties(
                submit: pageField.submit ?? "",
                next: pageField.next ?? "",
                back: pageField.back ?? "",
                backVisibility: pageField.backVisibility ?? true
            )
        )
    }
}
