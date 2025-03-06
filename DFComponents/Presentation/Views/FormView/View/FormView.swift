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

    @State private var showingAppearanceSheet = false

    var title: String = "Form View"

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.pages.isEmpty {
                    TabView {
                        ForEach(self.viewModel.pages, id: \.id) { page in
                                    PageView(controls: page.fields)
                                   .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                   .environmentObject(viewModel)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .padding()


                } else {
                    // Show loading state while form data is being fetched
                    loadingView()
                        .onAppear {
                            Task {
                                await viewModel.fetchForm()
                            }
                        }
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
            .environmentObject(styleManagerVM)
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

struct SectionView: View {
    let title: String
//    let icon: String
    let fields: [FieldEntity]
    
    @State private var isExpanded = true
    
    var body: some View {
        List {
            Section(header: sectionHeader()) {
                if isExpanded {
                    ForEach(fields, id: \.id) { field in
                        renderField(for: field)
                    }
                }
            }
        }
        .listStyle(PlainListStyle()) // Native list styling
    }
    
    // MARK: - Section Header
    @ViewBuilder
    private func sectionHeader() -> some View {
        Button(action: { isExpanded.toggle() }) {
            HStack {
//                Image(systemName: icon)
//                    .foregroundColor(.white)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
        }
    }
    
    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {
        switch field {
        case .radio ((_, let radioViewModel)):
            ControlFormBuilderView(titleControl: radioViewModel.control.label) {
                RadioButtonView(radioButtonVM: radioViewModel)
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

            }
        case .textBox((_, let textBoxViewModel)):
            ControlFormBuilderView(titleControl: textBoxViewModel.control.label ) {
                TextBoxComponent(viewModel: textBoxViewModel)
            }
            .opacity(textBoxViewModel.control.hidden ? 0 : 1)
        case .page((_, _)):
            EmptyView()
        case .section((_, let sectionViewModel)):
            SectionView(title: sectionViewModel.title, fields: sectionViewModel.controls)

        }
    }

}
    
struct PageView: View {
    var controls: [FieldEntity]
    @EnvironmentObject var viewModel: FormViewModel

    var body: some View {
        VStack(spacing: 20) {
               ForEach(controls, id: \.id) { field in
                   renderField(for: field)
                       .environmentObject(viewModel)
               }
           }
           .padding()
       }

    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {
        switch field {
        case .radio ((_, let radioViewModel)):
            ControlFormBuilderView(titleControl: radioViewModel.control.label) {
                RadioButtonView(radioButtonVM: radioViewModel)
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

            }
        case .textBox((_, let textBoxViewModel)):
            ControlFormBuilderView(titleControl: textBoxViewModel.control.label ) {
                TextBoxComponent(viewModel: textBoxViewModel)
            }
            .opacity(textBoxViewModel.control.hidden ? 0 : 1)
        case .page((_, _)):
            EmptyView()
        case .section((_, let sectionViewModel)):
            SectionView(title: sectionViewModel.title, fields: sectionViewModel.controls)

        }
    }

    
}


struct PageVieww: View {
    var controls: [FieldEntity]

    @ObservedObject var viewModel: FormViewModel

    var body: some View {
        VStack {
            ForEach(controls, id: \.id) { field in
                renderField(for: field)
            }
        }
    }

    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {
        switch field {
        case .radio ((_, let radioViewModel)):
            ControlFormBuilderView(titleControl: radioViewModel.control.label) {
                RadioButtonView(radioButtonVM: radioViewModel)
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
                // Call update in ViewModel to apply rules
                viewModel.applyFieldRules(by: field.id)
            }
        case .textBox((_, let textBoxViewModel)):
            ControlFormBuilderView(titleControl: textBoxViewModel.control.label ) {
                TextBoxComponent(viewModel: textBoxViewModel)
            }
            .opacity(textBoxViewModel.control.hidden ? 0 : 1)
        case .page((_, _)):
            EmptyView()
        case .section((_, let sectionViewModel)):
            SectionView(title: sectionViewModel.title, fields: sectionViewModel.controls)
        }
    }

}

//struct fieldsListView: View {
//    @ObservedObject var viewModel: FormViewModel  // ObservedObject prevents unnecessary re-renders
//
//    var body: some View {
//        ForEach(viewModel.fields, id: \.id) { field in
//            renderField(for: field)
//        }
//    }
//
//    @ViewBuilder
//    private func renderField(for field: FieldEntity) -> some View {
//        switch field {
//        case .radio ((_, let radioViewModel)):
//            ControlFormBuilderView(titleControl: radioViewModel.control.label) {
//                RadioButtonView(radioButtonVM: radioViewModel)
//            }
//            .opacity(radioViewModel.control.hidden ? 0 : 1)
//            .onReceive(
//                radioViewModel.$control
//                    .map { $0.options }
//                    .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
//                    .dropFirst()
//                    .removeDuplicates()
//            ) { newOptions in
//                print("Updated options: \(newOptions)")
//                // Call update in ViewModel to apply rules
//                viewModel.applyFieldRules(by: field.id)
//            }
//        case .textBox((_, let textBoxViewModel)):
//            ControlFormBuilderView(titleControl: textBoxViewModel.control.label ) {
//                TextBoxComponent(viewModel: textBoxViewModel)
//            }
//            .opacity(textBoxViewModel.control.hidden ? 0 : 1)
//        case .page((_, _)):
//            EmptyView()
//        case .section((_, _)):
//            EmptyView()
//        }
//    }
//}

struct WelcomeData: Codable {
    let logoURL: String
    let title: String
    let subtitle: String
    let questionCount: Int
    let buttonText: String
    let showQuestionCount: Bool
}

class WelcomeViewModel: ObservableObject {
    @Published var welcomeData: WelcomeData?

    func fetchWelcomeData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.welcomeData = WelcomeData(
                logoURL: "https://example.com/ibm-logo.png",
                title: "Welcome",
                subtitle: "Hi there, please fill out and submit this form.",
                questionCount: 50,
                buttonText: "Start",
                showQuestionCount: true
            )
        }
    }
}

struct WelcomeScreen: View {
    @StateObject private var viewModel = WelcomeViewModel()

    var body: some View {
        VStack {
            Spacer()
            
            if let data = viewModel.welcomeData {
                // Logo
                AsyncImage(url: URL(string: data.logoURL)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 40)
                .padding(.bottom, 16)
                
                // Title
                Text(data.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#173E67"))

                // Subtitle
                Text(data.subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#173E67"))
                    .padding(.top, 6)

                // Questions Count
                if data.showQuestionCount {
                    Text("\(data.questionCount) Questions")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#9EB3C2"))
                        .padding(.top, 16)
                }
                
                Spacer()
                
                // Start Button
                Button(action: {
                    print("Start button tapped")
                }) {
                    Text(data.buttonText)
                        .font(.system(size: 18, weight: .bold))
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#5989EF"))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .padding(.horizontal, 24)
                }
            } else {
                ProgressView() // Show loading indicator
            }
        }
        .padding(.bottom, 32)
        .onAppear {
            viewModel.fetchWelcomeData()
        }
    }
}

#Preview {
    WelcomeScreen()
}

