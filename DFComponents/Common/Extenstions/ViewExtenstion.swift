//
//  ViewExtenstion.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

extension View {
    //MARK: - Color
    func color(_ color: ColorType) -> some View {
        self.foregroundStyle(color.color)
    }
}
