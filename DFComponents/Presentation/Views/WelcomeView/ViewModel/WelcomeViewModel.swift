//
//  WelcomeViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

class WelcomeViewModel: ObservableObject {
    let id = UUID() // Ensure each instance is uniquely identifiable
    @Published var welcomeData: WelcomeEntity
    
    init(welcomeData: WelcomeEntity) {
        self.welcomeData = welcomeData
    }

}

struct WelcomeEntity {
    let logoURL: String
    let title: String
    let subtitle: String
    let questionCount: Int
    let buttonText: String
    let showQuestionCount: Bool
        
    init(logoURL: String, title: String, subtitle: String, questionCount: Int, buttonText: String, showQuestionCount: Bool) {
        self.logoURL = logoURL
        self.title = title
        self.subtitle = subtitle
        self.questionCount = questionCount
        self.buttonText = buttonText
        self.showQuestionCount = showQuestionCount
    }
    
    init(cardWelcomeData: CardWelcomeData, questionCount: Int) {
        self.logoURL = cardWelcomeData.logo ?? ""
        self.title = cardWelcomeData.title ?? ""
        self.subtitle = cardWelcomeData.description ?? ""
        self.showQuestionCount = cardWelcomeData.showQuestionsCount ?? false
        self.questionCount = questionCount
        self.buttonText = "Start"
    }
}
