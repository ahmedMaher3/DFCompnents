//
//  ColorType.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

enum ColorType {
    case primaryBlue
    case primaryGray
    case customColor(Color)


    var color: Color {
        switch self {
            case .primaryBlue:
                return Color("primaryBlue")
            case .primaryGray:
                return Color("primaryGray")
            case .customColor(let colorName):
                return Color(colorName)
        }
    }
}
