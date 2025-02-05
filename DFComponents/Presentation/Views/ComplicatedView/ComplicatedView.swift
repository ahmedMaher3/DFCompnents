//
//  ComplicatedView.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/5/25.
//

import SwiftUI

struct ComplicatedView: View {
    @ObservedObject var viewModel = TestViewModel()
    
    var body: some View {
//        ScrollView {
//            LazyVStack {
                List(viewModel.objectsList) { object in
                    NavigationLink(destination: SimpleView()) {
                        ComponentsListenersView(object: object) {
                            print(object.text)
                        } onDateValueChange: {
                            print(object.date.formatted())
                        }
                    }
//                }
//            }
        }
        .navigationTitle("Huge List")
    }
}

struct ComponentsListenersView: View {
    @ObservedObject var object: TestObject
    var onTextValueChange: () -> Void
    var onDateValueChange: () -> Void
    
    var body: some View {
        VStack {
//            TextField("Enter text", text: $object.text)
//                .onChange(of: object.text) { _, newValue in
//                    print("Textfield value changed to: \(newValue)")
//                    onTextValueChange()
//                }
            ValidatedTextField(text: $object.text, validation: { input in
                input.allSatisfy { $0.isLetter }
            }, onValidationError: { error in
                print("Validation error: \(error)")
            }) {
                onTextValueChange()
            }
            
            DatePicker("Select date", selection: $object.date, displayedComponents: .date)
                .onChange(of: object.date) { _, newValue in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    print("Date changed to: \(dateFormatter.string(from: newValue))")
                    onDateValueChange()
                }
        }
    }
}

struct ValidatedTextField: View {
    @Binding var text: String
    let validation: (String) -> Bool
    @State private var isValid: Bool = true
    let onValidationError: (String) -> Void
    var onTextValueChange: () -> Void
    
    var body: some View {
        TextField("Enter text", text: $text)
            .textFieldStyle(.roundedBorder)
            .onChange(of: text, { oldValue, newValue in
                let isValid = validation(newValue)
                self.isValid = isValid
                if !isValid {
                    onValidationError(newValue)
//                    self.text = oldValue
                } else {
                    self.text = newValue
                    onTextValueChange()
                }
            })
            .overlay(
                isValid ? nil :
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
            )
    }
}

class TestObject: Identifiable, ObservableObject {
    var id: UUID = UUID()
    @Published var text: String = ""
    @Published var date: Date = Date()
}

class TestViewModel: ObservableObject {
    @Published var objectsList: [TestObject] = []
    
    init() {
        objectsList = (0..<1000).map { _ in
            TestObject()
        }
    }
}

struct SimpleView: View {
    @State private var batteryLevel: Double = 0.75
    
    var body: some View {
        List {
            ForEach(0..<1000) { index in
                Text("Item \(index)")
                Image(systemName: "wifi", variableValue: Double(index / 100))
                Image(systemName: "chart.bar.fill", variableValue: batteryLevel)
                Slider(value: $batteryLevel, in: 0...1)
            }
        }
    }
}

#Preview {
    ComplicatedView()
}
