//
//  ViewExtenstion.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

extension View {
    //MARK: - Color
    func color(_ color: Color) -> some View {
        self.foregroundStyle(color)
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
