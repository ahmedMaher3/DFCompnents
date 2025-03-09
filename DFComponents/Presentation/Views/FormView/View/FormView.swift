//
//  FormView.swift
//  DFComponents
//
//  Created by Ahmed Maher on 26/02/2025.
//
import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct FormView: View {
    @StateObject var viewModel: FormViewModel = FormViewModel()
    @StateObject private var styleManagerVM = StyleManagerViewModel()

    @Environment(\.locale) private var locale
    @State private var currentLocale: Locale = .current

    @State private var showingAppearanceSheet = false

    var title: String = "FormView"

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.pages.isEmpty {
                    
                    if self.viewModel.mode == .card {
                        TabView {
                            ForEach(self.viewModel.pages, id: \.id) { page in
                                GeometryReader { geometry in
                                ScrollView {
                                        
                                        VStack {
                                            Spacer()
                                            PageView(controls: page.fields)
                                                .frame(maxWidth: .infinity) // Ensures it expands properly
                                                .environmentObject(viewModel)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity, minHeight: geometry.size.height) // Uses container height
                                    }
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: self.viewModel.mode == .card ? .always : .never ))
                        .if(self.viewModel.mode == .card) { tab in
                            tab.frame(height: UIScreen.main.bounds.height / 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        .shadow(radius: 5)
                                )
                                .padding()
                        }
                    } else {
                        TabView {
                            ForEach(self.viewModel.pages, id: \.id) { page in
                                PageView(controls: page.fields)
                                    .environmentObject(viewModel)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it fills space
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: self.viewModel.mode == .card ? .always : .never ))
                    }
//                    }
                    
                } else {
                    // Show loading state while form data is being fetched
                    loadingView()
                        .onAppear {
                            Task {
                                await viewModel.fetchForm()
                                viewModel.warnings.map { entity in
                                    print(entity)
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#FAFBFF"))
            .navigationBarTitle(title, displayMode: .inline)
            .environmentObject(styleManagerVM)
            .onAppear {
                currentLocale = locale
            }
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

//#Preview {
//    FormView()
//}
