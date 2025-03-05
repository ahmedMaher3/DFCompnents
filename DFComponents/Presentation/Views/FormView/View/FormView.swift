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
                        fieldsListView(viewModel: viewModel)
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

struct fieldsListView: View {
    @ObservedObject var viewModel: FormViewModel  // ObservedObject prevents unnecessary re-renders

    var body: some View {
        ForEach(viewModel.fields, id: \.id) { field in
            renderField(for: field)
        }
    }

    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {
        switch field {
            case .radio((_, let radioViewModel)):
                ControlFormBuilderView {
                    EmptyView()
                } controlType: {
                    RadioButtonView(radioButtonVM: radioViewModel)
                } footerView: {
                    EmptyView()
                }
                .opacity(radioViewModel.control.hidden ? 0 : 1)

            case .textBox((_, let textBoxViewModel)):
                ControlFormBuilderView {
                    EmptyView()
                } controlType: {
                    TextBoxComponent(viewModel: textBoxViewModel)
                } footerView: {
                    EmptyView()
                }
                .opacity(textBoxViewModel.control.hidden ? 0 : 1)

            case .number((_, let numberViewModel)):
                ControlFormBuilderView {
                    renderHeader(for: numberViewModel.baseProperties)
                } controlType: {
                    NumberFieldComponent(viewModel: numberViewModel)
                } footerView: {
                    renderFooter(for: numberViewModel.numberFieldModel.base)
            }
        }
    }
    /*
     @ViewBuilder
     private func renderField(for field: FieldEntity) -> some View {
     switch field {
     case .radio((_, let radioViewModel)):
     ControlFormBuilderView {
     EmptyView()
     } controlType: {
     RadioButtonView(radioButtonVM: radioViewModel)
     } footerView: {
     EmptyView()
     }
     .opacity(radioViewModel.control.hidden ? 0 : 1)
     .onReceive(
     radioViewModel.$control
     .map { $0.options }
     .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
     .dropFirst()
     .removeDuplicates()
     ) { newOptions in
     print("Updated options: \(newOptions)")
     viewModel.applyFieldRules(by: field.id)
     }

     case .textBox((_, let textBoxViewModel)):
     ControlFormBuilderView {
     EmptyView()
     } controlType: {
     TextBoxComponent(viewModel: textBoxViewModel)
     } footerView: {
     EmptyView()
     }
     .opacity(textBoxViewModel.control.hidden ? 0 : 1)

     case .number((_, let numberViewModel)):
     ControlFormBuilderView {
     /// Header View
     if let baseProperties = numberViewModel.baseProperties {
     HeaderComponentView(viewModel: HeaderComponentViewModel(baseProperties: baseProperties)) {
     HStack(alignment: .firstTextBaseline, spacing: 4) {
     if let label = baseProperties.label {
     Text(label)
     .font(.headline)
     .foregroundColor(.primary)
     }
     if let subLabel = baseProperties.subLabel {
     Text(subLabel)
     .font(.subheadline)
     .foregroundStyle(.red)
     }
     if let tooltip = baseProperties.tooltip {
     HStack {
     Text("ⓘ")
     .font(.system(size: 18))
     .foregroundStyle(.gray)

     Text(tooltip)
     .font(.system(size: 20))
     .foregroundStyle(.gray)
     .offset(y: 5)
     }
     }
     }
     }
     .padding(.bottom, 8)
     }
     } controlType: {
     /// Control View
     NumberFieldComponent(viewModel: numberViewModel)
     } footerView: {
     /// Footer View
     if let interactiveProperties = numberViewModel.interactiveProperties {
     FooterComponentView(viewModel: FooterComponentViewModel(interactiveBaseProperties: interactiveProperties.base)) {
     HStack {
     if interactiveProperties.addNote {
     Text("Note")
     }
     if interactiveProperties.addAttachment {
     Text("|| Attachment")
     }
     }
     }
     }
     }
     }
     }
     */
    @ViewBuilder
    private func renderHeader(for baseProperties: BaseProperties?) -> some View {
        if let baseProperties = baseProperties {
            HeaderComponentView(viewModel: HeaderComponentViewModel(baseProperties: baseProperties)) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    if let label = baseProperties.label {
                        Text(label)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    if let subLabel = baseProperties.subLabel {
                        Text(subLabel)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }
                    if let tooltip = baseProperties.tooltip {
                        HStack {
                            Text("ⓘ")
                                .font(.system(size: 18))
                                .foregroundStyle(.gray)

                            Text(tooltip)
                                .font(.system(size: 20))
                                .foregroundStyle(.gray)
                                .offset(y: 5)
                        }
                    }
                }
            }
            .padding(.bottom, 8)
        } else {
            EmptyView() // If no header is available
        }
    }

    @ViewBuilder
    private func renderFooter(for interactiveProperties: InteractiveField?) -> some View {
        if let interactiveProperties = interactiveProperties {
            FooterComponentView(viewModel:
                                    FooterComponentViewModel(interactiveBaseProperties: interactiveProperties)) {
                HStack {
                    if interactiveProperties.addNote {
                        Text("Note")
                    }
                    if interactiveProperties.addAttachment {
                        Text("|| Attachment")
                    }
                }
            }
        } else {
            EmptyView() // If no footer is available
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
