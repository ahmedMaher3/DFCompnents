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
                    Spacer()
                    TabView(selection: $currentPage) {
                        ForEach(viewModel.pages.indices, id: \.self) { index in
//                            viewModel.pages[index].pageField?.renderPage(viewModel: viewModel, index: index)
                            PageView(pageViewModel: PageViewModel(controls: viewModel.pages[index].fields, pageField: viewModel.pages[index].pageField))
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
                    Spacer()
                    handleFooter(pageField: self.viewModel.pages[currentPage].pageField)
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
    
    private func handleFooter(pageField: PageField) -> FooterView {
        return FooterView(
            currentPage: $currentPage,
            totalPages: viewModel.pages.count,
            pageProperties: pageField.pageProperties ?? PageProperties(
                submit: "",
                next: "",
                back: "",
                backVisibility: true
            )
        )
    }

}


struct FooterView: View {
    @Binding var currentPage: Int
    let totalPages: Int
    let pageProperties: PageProperties
    
    var body: some View {
        HStack {
            
            if pageProperties.backVisibility {
                if currentPage != 0 {
                    Button(action: {
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text(pageProperties.back)
                        }
                        .foregroundColor(currentPage > 0 ? .blue : .gray)
                    }
                    //                .disabled(currentPage == 0)
                }
            }

            Spacer()

            if currentPage < totalPages - 1 {
                Button(action: {
                    if currentPage < totalPages - 1 {
                        currentPage += 1
                    }
                }) {
                    HStack {
                        Text(pageProperties.next)
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(currentPage < totalPages - 1 ? .blue : .gray)
                }
                //            .disabled(currentPage >= totalPages - 1)
            }
        }
            
        .padding()
        .frame(height: 55)
        .background(Color(.systemGray6))

    }
}

