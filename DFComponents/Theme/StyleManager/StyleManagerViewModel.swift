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
        styleManager.borderValidColor = Color(hex: apiResponse.borderValidColor)
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
    let borderValidColor: String
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
        // Simulate API call with styled colors
        let mockResponse = APIStyleResponse(
            primaryTextColor: "#1D3557", // Dark Blue
            secondaryTextColor: "#457B9D", // Soft Blue
            borderColor: "#D0D9E2", 
            borderValidColor: "#7BE9B8" ,
            errorColor: "#FFA500", // Keep Orange
            titleFontName: "Helvetica",
            titleFontSize: 18,
            subtitleFontName: "Helvetica",
            subtitleFontSize: 12,
            borderWidth: 2,
            cornerRadius: 10
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(mockResponse)
        }
    }
}


