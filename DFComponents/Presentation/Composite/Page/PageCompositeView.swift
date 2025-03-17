//
//  PageCompositeView.swift
//  DFComponents
//
//  Created by Eslam on 16/03/2025.
//
//
import SwiftUI

struct PageCompositeView: FormComponent, View {
    let id: String
    @EnvironmentObject var viewModel: FormViewModel
    @ObservedObject var pageViewModel: PageViewModel

    init(pageViewModel: PageViewModel, id: String = "") {
        self.pageViewModel = pageViewModel
        self.id = id
    }

    var body: some View {
        render()
    }

    // MARK: - FormComponent Implementation
    @ViewBuilder
    func render() -> some View {
        if viewModel.mode == .classic {
            classicView
        } else {
            modernView
        }
    }

    private var classicView: some View {
        List {
            ForEach(pageViewModel.controls, id: \.id) { field in
                renderField(for: field)
                    .environmentObject(viewModel)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .listStyle(PlainListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var modernView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer()
                    ForEach(pageViewModel.controls, id: \.id) { field in
                        renderField(for: field)
                            .frame(maxWidth: .infinity)
                            .environmentObject(viewModel)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
            }
        }
    }

    @ViewBuilder
    private func renderField(for field: FieldEntity) -> some View {
        switch field {
        case .radio((_, let radioViewModel)):
            createFieldContainer(for: field, control: { RadioButtonView(radioButtonVM: radioViewModel) })
                .opacity(radioViewModel.control.hidden ? 0 : 1)

        case .textBox((_, let textBoxViewModel)):
            createFieldContainer(for: field, control: { TextBoxComponent(viewModel: textBoxViewModel) })
                .opacity(textBoxViewModel.control.hidden ? 0 : 1)

        case .number((_, let numberViewModel)):
            createFieldContainer(for: field, control: {
                NumberFieldComponent(viewModel: numberViewModel)
                    .onReceive(numberViewModel.$warningsMessagesDictionary) { newValue in
                        Task { @MainActor in
                            viewModel.warningsMessagesDictionary = newValue
                        }
                    }
            })

        case .page((_, _)):
            EmptyView()

        case .section((_, let sectionViewModel)):
            SectionView(sectionViewModel: sectionViewModel, fields: sectionViewModel.controls, isExpanded: sectionViewModel.sectionField.isExpandedStatus)
                .onReceive(sectionViewModel.objectWillChange) { _ in
                    print("Updated Values: \(sectionViewModel.controls)")
                }
        }
    }

    private func createFieldContainer<Content: View>(
        for field: FieldEntity,
        @ViewBuilder control: @escaping () -> Content
    ) -> some View {
        BaseFieldContainerView(
            fieldEntity: field,
            controlType: control,
            warningMessage: getWarningBinding(for: field)
        )
    }

    private func getWarningBinding(for field: FieldEntity) -> Binding<String?> {
        Binding<String?>(
            get: { viewModel.warningsMessagesDictionary?[field.id]?.joined(separator: "") },
            set: { newValue in
                viewModel.warningsMessagesDictionary?[field.id] = newValue?.isEmpty == false ? [newValue!] : nil
            }
        )
    }
}


