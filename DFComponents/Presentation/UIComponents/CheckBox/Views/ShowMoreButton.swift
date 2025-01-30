//
//  ShowMoreButton.swift
//  DFComponents
//
//  Created by Eslam on 30/01/2025.
//

import SwiftUI


struct ShowMoreButton: View {
    var showAll: Bool
    var questionID: String
    var itemsCount: Int
    var showAllAnswersForQuestion: Binding<[String: Bool]>

    var body: some View {
        if itemsCount > 3 {
            Button(action: {
                if let currentValue = showAllAnswersForQuestion.wrappedValue[questionID] {
                    showAllAnswersForQuestion.wrappedValue[questionID] = !currentValue
                }
            }) {
                Text(showAll ? "Show Less" : "Show More")
                    .font(.subheadline)
                    .color(.blue)
                    .padding(.top, 8)
            }
            .buttonStyle(PlainButtonStyle()) // Prevent the button from triggering unintended taps
            .background(.clear)
        }
    }
}
