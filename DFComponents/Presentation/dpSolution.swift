//
//  dpSolution.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/25/25.
//

import SwiftUI

// MARK: - Base Protocol for Form Components
protocol FormComponent: Identifiable {
    var id: String { get }
    @ViewBuilder func render() -> AnyView
}

// MARK: - Form Model
struct DynamicForm: Identifiable, Decodable, FormComponent {
    let id: String
    let title: String
    let pages: [DynamicPage]

    @ViewBuilder
    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .padding()

                ForEach(pages) { page in
                    page.render()
                }
            }
        )
    }
}

// MARK: - Page Model
struct DynamicPage: Identifiable, Decodable, FormComponent {
    let id: String
    let label: String
    let sections: [DynamicSection]

    @ViewBuilder
    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Text(label)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                    .padding()

                ForEach(sections) { section in
                    section.render()
                }
            }
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white).shadow(radius: 2))
        )
    }
}

// MARK: - Section Model
struct DynamicSection: Identifiable, Decodable, FormComponent {
    let id: String
    let label: String
    let fields: [DynamicField]

    @ViewBuilder
    func render() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Text(label)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding()

                ForEach(fields) { field in
                    field.render()
                }
            }
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray6)))
        )
    }
}

// MARK: - Field Model with Factory Pattern
class DynamicField: ObservableObject, Identifiable, Decodable, FormComponent {
    let id: String
    let label: String
    let type: FieldTypee
    let renderStrategy: RenderStrategy

    @Published var value: String = "" {
        didSet {
            notifyObservers()
        }
    }

    private var observers: [ObserverField] = []

    init(id: String, label: String, type: FieldTypee) {
        self.id = id
        self.label = label
        self.type = type
        self.renderStrategy = DynamicFormFactory.getRenderStrategy(for: type)
    }

    func addObserver(_ observer: ObserverField) {
        observers.append(observer)
    }

    func notifyObservers() {
        observers.forEach { $0.update(self) }
    }

    @ViewBuilder
    func render() -> AnyView {
        renderStrategy.render(field: self)
    }

    // Custom Decoding Logic
    enum CodingKeys: String, CodingKey {
        case id, label, type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.label = try container.decode(String.self, forKey: .label)
        let typeString = try container.decode(String.self, forKey: .type)
        self.type = FieldTypee(rawValue: typeString) ?? .textBox
        self.renderStrategy = DynamicFormFactory.getRenderStrategy(for: self.type)
    }
}

// MARK: - Field Types Enum
enum FieldTypee: String, Decodable {
    case textBox = "TextBox"
    case radio = "Radio"
    case number = "Number"
    case section = "Section"
}

// MARK: - Factory Pattern for Creating Fields
class DynamicFormFactory {
    static func getRenderStrategy(for type: FieldTypee) -> RenderStrategy {
        switch type {
        case .textBox:
            return TextBoxRenderStrategy()
        case .radio:
            return RadioRenderStrategy()
        case .number:
            return NumberRenderStrategy()
        case .section:
            return TextBoxRenderStrategy() // Sections should be handled differently.
        }
    }
}

// MARK: - Strategy Pattern for Rendering Fields
protocol RenderStrategy {
    @ViewBuilder func render(field: DynamicField) -> AnyView
}

struct TextBoxRenderStrategy: RenderStrategy {
    @ViewBuilder func render(field: DynamicField) -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Text(field.label).font(.headline)
                TextField("Enter text...", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
        )
    }
}

struct RadioRenderStrategy: RenderStrategy {
    @ViewBuilder func render(field: DynamicField) -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Text(field.label).font(.headline)
                Picker("Select an option", selection: .constant(0)) {
                    Text("Option 1").tag(1)
                    Text("Option 2").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
        )
    }
}

struct NumberRenderStrategy: RenderStrategy {
    @ViewBuilder func render(field: DynamicField) -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Text(field.label).font(.headline)
                TextField("Enter number...", text: .constant(""))
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
        )
    }
}

// MARK: - Observer Pattern
protocol ObserverField {
    func update(_ field: DynamicField)
}

// MARK: - ViewModel for Form
class FormViewModell: ObservableObject {
    @Published var form: DynamicForm?

    func loadFormData() {
        guard let url = Bundle.main.url(forResource: "checkSurvey", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decodedForm = try? JSONDecoder().decode(DynamicForm.self, from: data) else {
            print("Failed to load JSON")
            return
        }

        self.form = decodedForm
    }
}

// MARK: - Main Form View
struct FormVieww: View {
    @StateObject private var viewModel = FormViewModell()

    var body: some View {
        NavigationStack {
            if let form = viewModel.form {
                VStack {
                    Text(form.title)
                        .font(.largeTitle)
                        .padding()

                    List {
                        ForEach(form.pages) { page in
                            Section(header: Text(page.label).font(.title2)) {
                                ForEach(page.sections) { section in
                                    Section(header: Text(section.label)) {
                                        ForEach(section.fields) { field in
                                            field.render()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle(form.title)
            } else {
                ProgressView("Loading Form...")
                    .onAppear {
                        viewModel.loadFormData()
                    }
            }
        }
    }
}
