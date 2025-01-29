//
//  DFComponentsApp.swift
//  DFComponents
//
//  Created by ahmed maher on 29/01/2025.
//

import SwiftUI

@main
struct DFComponentsApp: App {
    var body: some Scene {
        WindowGroup {
            let config = TextBoxConfiguration(
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
            DFComponentsView(components: [.textBox(config: config)])
        }
    }
}
