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

    @State private var showingAppearanceSheet = false

    var title: String = "Form View"

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.pages.isEmpty {
                    
                    TabView {
                        ForEach(self.viewModel.pages.keys.sorted(), id: \.self) { pageId in // 2 pages
                            if let controls = self.viewModel.pages[pageId] {
                                PageView(controls: controls, viewModel: self.viewModel)
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
                    // Show loading state while form data is being fetched
                    loadingView()
                        .onAppear {
                            Task {
                                await viewModel.fetchForm()
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#FAFBFF"))
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

#Preview {
    FormView()
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
                // Call update in ViewModel to apply rules
//                viewModel.applyFieldRules(by: field.id)
            }
        case .textBox((_, let textBoxViewModel)):
            ControlFormBuilderView(titleControl: textBoxViewModel.control.label ) {
                TextBoxComponent(viewModel: textBoxViewModel)
            }
            .opacity(textBoxViewModel.control.hidden ? 0 : 1)
        case .page((_, _)):
            EmptyView()
        case .section((_, _)):
            EmptyView()
        }
    }

    
}


struct PageView: View {
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
