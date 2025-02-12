//
//  StyleManagerViewModel.swift
//  FormBuilder
//
//  Created by hassan elshaer on 11/02/2025.
//

import Foundation
import SwiftUI

class StyleManagerViewModel: ObservableObject {
    @Published var styleManager = StyleManager()

    func updateStyles(from apiResponse: APIStyleResponse) {
        styleManager.primaryTextColor = Color(hex: apiResponse.primaryTextColor)
        styleManager.secondaryTextColor = Color(hex: apiResponse.secondaryTextColor)
        styleManager.borderColor = Color(hex: apiResponse.borderColor)
        styleManager.errorColor = Color(hex: apiResponse.errorColor)
        styleManager.titleFont = Font.custom(apiResponse.titleFontName, size: apiResponse.titleFontSize)
        styleManager.subtitleFont = Font.custom(apiResponse.subtitleFontName, size: apiResponse.subtitleFontSize)
        styleManager.borderWidth = apiResponse.borderWidth
        styleManager.cornerRadius = apiResponse.cornerRadius
    }
}

struct APIStyleResponse: Codable {
    let primaryTextColor: String
    let secondaryTextColor: String
    let borderColor: String
    let errorColor: String
    let titleFontName: String
    let titleFontSize: CGFloat
    let subtitleFontName: String
    let subtitleFontSize: CGFloat
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
}

class APIService {
    static func fetchStyles(completion: @escaping (APIStyleResponse?) -> Void) {
        // Simulate API call
        let mockResponse = APIStyleResponse(
            primaryTextColor: "#FF0000", // Red
            secondaryTextColor: "#00FF00", // Green
            borderColor: "#0000FF", // Blue
            errorColor: "#FFA500", // Orange
            titleFontName: "Helvetica",
            titleFontSize: 24,
            subtitleFontName: "Helvetica",
            subtitleFontSize: 18,
            borderWidth: 2,
            cornerRadius: 10
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(mockResponse)
        }
    }
}
