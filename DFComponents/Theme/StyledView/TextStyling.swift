//
//  TextStyling.swift
//  FormBuilder
//
//  Created by hassan elshaer on 11/02/2025.
//

import SwiftUI
import Foundation

struct TextStyling: ViewModifier {
    let font: Font
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func styledText(font: Font, color: Color) -> some View {
        self.modifier(TextStyling(font: font, color: color))
    }
}
