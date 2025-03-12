//
//  FormView.swift
//  DFComponents
//
//  Created by Ahmed Maher on 26/02/2025.
//
import SwiftUI

struct FormView: View {
    @StateObject var viewModel: FormViewModel = FormViewModel()
    @StateObject var stepProgressViewModel: StepProgressViewModel = StepProgressViewModel()
    @StateObject private var styleManagerVM = StyleManagerViewModel()

    @Environment(\.locale) private var locale
    @State private var currentLocale: Locale = .current

    @State private var showingAppearanceSheet = false
    @State private var currentPage: Int = 0


    var title: String = "FormView"

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.pages.isEmpty {
                    StepProgressView(viewModel: stepProgressViewModel)
                    TabView(selection: $currentPage) {
                        ForEach(viewModel.pages.indices, id: \.self) { index in
                            PageView(pageViewModel: PageViewModel(controls: viewModel.pages[index].fields))
                                .environmentObject(viewModel)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: self.viewModel.mode == .card ? .always : .never ))
                    .onChange(of: currentPage) { oldValue,newPage in
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
                        tab.frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it fills space
                    }

                } else {
                    loadingView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#FAFBFF"))
            .navigationBarTitle(title, displayMode: .inline)
            .environmentObject(styleManagerVM)
            .onAppear {
                currentLocale = locale
                Task {
                    await viewModel.fetchForm()
                    updateStepProgress()
                    viewModel.warnings.map { entity in
                        print(entity)
                    }
                }
            }

        }
    }

    private func updateStepProgress() {
        stepProgressViewModel.totalPages = viewModel.pages.count
        stepProgressViewModel.updateProgress()
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

    func switchLanguage(to localeIdentifier: String) {
        currentLocale = Locale(identifier: localeIdentifier)
        UserDefaults.standard.set(localeIdentifier, forKey: "selectedLocale")
        //
        //        // Restart the app for full effect
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: SplashView().environment(\.locale, currentLocale))
            window.makeKeyAndVisible()
        }
    }

}

