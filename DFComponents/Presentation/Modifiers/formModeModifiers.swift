//
//  formModeModifiers.swift
//  DFComponents
//
//  Created by ahmed maher on 19/03/2025.
//

import SwiftUI

// MARK: - View Modifier for Frame Styling
 extension View {
    func frameModifier(for mode: FormType) -> some View {
        Group {
            if mode == .card {
                self.frame(height: UIScreen.main.bounds.height / 2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
                    .padding()
            } else {
                self.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
