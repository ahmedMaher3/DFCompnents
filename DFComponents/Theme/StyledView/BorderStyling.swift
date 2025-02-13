//
//  BorderStyling.swift
//  FormBuilder
//
//  Created by hassan elshaer on 11/02/2025.
//

import Foundation
import SwiftUI

struct BorderStyling: ViewModifier {
    let color: Color
    let width: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: width)
            )
    }
}

extension View {
    func styledBorder(color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        self.modifier(BorderStyling(color: color, width: width, cornerRadius: cornerRadius))
    }
}
