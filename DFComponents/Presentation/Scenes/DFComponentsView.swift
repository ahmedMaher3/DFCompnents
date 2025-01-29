//
//  DFComponentsView.swift
//  DFComponents
//
//  Created by ahmed maher on 29/01/2025.
//

import SwiftUI

// MARK: - DFComponentsView
import SwiftUI

struct DFComponentsView: View {
    let components: [ComponentType]
    
    var body: some View {
        List(components, id: \.self) { component in
            VStack(spacing: 10) { // Add some spacing between components
                switch component {
                case .textBox(let config):
                    TextBoxComponent(viewModel: TextBoxViewModel(config: config))
                        .frame(maxWidth: .infinity) // Make TextBox take full width
                case .dropDown(let options):
                    Text("DropDown: \(options.joined(separator: ", "))")
                        .frame(maxWidth: .infinity) // Make DropDown take full width
                case .checkBox(let isChecked):
                    Text("Checkbox is \(isChecked ? "Checked" : "Unchecked")")
                        .frame(maxWidth: .infinity) // Make Checkbox take full width
                case .dateTime(let selectedDate):
                    Text("DateTime: \(selectedDate)")
                        .frame(maxWidth: .infinity) // Make DateTime take full width
                }
            }
            .padding(.vertical, 5) // Optional: Add some vertical padding for list rows
        }
        .navigationTitle("Form View")
        .listStyle(PlainListStyle()) // Optional: To remove default list styling
    }
}

#Preview {
    let textBoxConfig = TextBoxConfiguration(
        title: "What is your Name?",
        subtitle: nil,
        placeholder: "Enter your name",
        inputType: .mixed,
        minLength: 2,
        prefixOptions: ["Mr", "Ms"],
        suffixOptions: ["Jr"],
        requiresPrefix: true,
        requiresSuffix: true
    )

    let components: [ComponentType] = [
        .textBox(config: textBoxConfig)
    ]

    return DFComponentsView(components: components)
}
