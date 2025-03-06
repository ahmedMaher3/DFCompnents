//
//  FormView.swift
//  DFComponents
//
//  Created by Ahmed Maher on 26/02/2025.
//
import SwiftUI

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
                Text(title.localizedKey)
                if !viewModel.fields.isEmpty {
                    Form {
                        FieldsListView(viewModel: viewModel)
                    }
                    .padding()
                    Text(locale.identifier)
                    Button("Switch to Arabic") {
                        switchLanguage(to: "ar")
                    }

                    Button("Switch to English") {
                        switchLanguage(to: "en")
                    }
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
            .navigationTitle(title.localizedKey)
            .navigationBarTitleDisplayMode(.inline)
            //            .navigationBarTitle(LocalizedStringKey(title), displayMode: .inline)
            .environmentObject(styleManagerVM)
            .onAppear {
                currentLocale = locale
            }
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

    // Loading view to be displayed while fetching the form data
    private func loadingView() -> some View {
        VStack {
            Text("Loading form data...")
                .padding()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}


extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    var localizedKey: LocalizedStringKey {
        LocalizedStringKey(self)
    }
}
