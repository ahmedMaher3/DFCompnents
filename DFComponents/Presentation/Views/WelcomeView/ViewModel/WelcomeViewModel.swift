//
//  WelcomeViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

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
