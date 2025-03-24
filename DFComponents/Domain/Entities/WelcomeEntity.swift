//
//  WelcomeEntity.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/23/25.
//

import Foundation

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
    
    init(cardWelcomeData: CampaignItem?, questionCount: Int) {
        self.logoURL = cardWelcomeData?.logo ?? ""
        self.title = cardWelcomeData?.title ?? ""
        self.subtitle = cardWelcomeData?.description ?? ""
        self.showQuestionCount = cardWelcomeData?.showQuestionsCount ?? false
        self.questionCount = questionCount
        self.buttonText = "Start"
    }
}
