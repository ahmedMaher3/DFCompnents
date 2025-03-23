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
/*
 private struct FormContentView: View {
 @ObservedObject var viewModel: FormViewModel
 @ObservedObject var stepProgressViewModel: StepProgressViewModel
 @ObservedObject private var router = Router()
 @Binding var currentPage: Int

 var body: some View {
 VStack {
 StepProgressView(viewModel: stepProgressViewModel)
 Spacer()
 TabView(selection: $currentPage) {
 ForEach(viewModel.pages.indices, id: \.self) { index in
 PageView(pageViewModel: PageViewModel(
 controls: viewModel.pages[index].fields,
 showHeader: false,
 showFooter: index == (viewModel.pages.indices.last ?? 0),
 pageFooter: PageFooterEntity(classicPageFooter: self.viewModel.footer!)
 )
 )
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
 .onAppear {
 if viewModel.mode == .card {
 if let welcomeCardData: CardWelcomeData = viewModel.welcomeData {
 router.present(.welcomeView(viewModel: WelcomeViewModel(welcomeData: WelcomeEntity(cardWelcomeData: welcomeCardData, questionCount: self.viewModel.pages.count))))
 }
 }
 }
 .fullScreenCover(item: $router.presentedRoute) { route in
 router.destination(for: route)
 }
 .environmentObject(router)
 }
 }
 */
private struct FormContentView: View {
    @ObservedObject var viewModel: FormViewModel
    @ObservedObject var stepProgressViewModel: StepProgressViewModel
    @ObservedObject private var router = Router()
    @Binding var currentPage: Int

    @State private var lastScrollOffset: CGFloat = 0
    @State private var showHeader: Bool = true
    @State private var showStepper: Bool = false

    var body: some View {
        VStack(spacing: 0) {

            if showHeader {
                Text("Header View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showHeader)
            }

            if showStepper {
                StepProgressView(viewModel: stepProgressViewModel)
            }

            Spacer()

            ScrollView {
                VStack {
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .global).minY)
                            .frame(height: 0)
                    }
                    
//                    TabView(selection: $currentPage) {
//                        ForEach(viewModel.pages.indices, id: \.self) { index in
//                            PageView(pageViewModel: PageViewModel(
//                                controls: viewModel.pages[index].fields,
//                                showHeader: false,
//                                showFooter: index == (viewModel.pages.indices.last ?? 0),
//                                pageFooter: PageFooterEntity(classicPageFooter: self.viewModel.footer!)
//                            ))
//                            .environmentObject(viewModel)
//                            .tag(index)
//                            .containerRelativeFrame(.vertical)
//                        }
//                    }
//                    .frame(height: UIScreen.main.bounds.height * 0.7)
//                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))


                    // Content
                    ForEach(1...50, id: \.self) { i in
                        Text("Field \(i)")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .padding(.horizontal)
                    }

                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { newOffset in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { // Delay updates
                    withAnimation {
                        if newOffset < lastScrollOffset - 5 || lastScrollOffset == 0 {
                            showHeader = false
                            showStepper = true
                        } else if newOffset > -10 {
                            showHeader = true
                        }
                    }
                    lastScrollOffset = newOffset
                }
            }

            // ✅ Footer
            PageFooterView(currentPage: $currentPage, totalPages: viewModel.pages.count)
        }
        .onAppear {
            if viewModel.mode == .card {
                if let welcomeCardData: CardWelcomeData = viewModel.welcomeData {
                    router.present(.welcomeView(viewModel: WelcomeViewModel(welcomeData: WelcomeEntity(cardWelcomeData: welcomeCardData, questionCount: self.viewModel.pages.count))))
                }
            }
        }
        .fullScreenCover(item: $router.presentedRoute) { route in
            router.destination(for: route)
        }
        .environmentObject(router)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
