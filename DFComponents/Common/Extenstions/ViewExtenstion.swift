//
//  ViewExtenstion.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

extension View {
    func color(_ color: ColorType) -> some View {
        self.foregroundStyle(Color(color.name))
    }
}
