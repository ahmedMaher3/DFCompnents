//
//  ImageExtenstion.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI
extension Image {
    func customizeImage(width: CGFloat,
                        height: CGFloat,
                        type color: ColorType,
                        contentMode: ContentMode,
                        renderingMode: TemplateRenderingMode) -> some View {
        self
            .renderingMode(renderingMode)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: width, height: height)
            .color(color)
    }
}
