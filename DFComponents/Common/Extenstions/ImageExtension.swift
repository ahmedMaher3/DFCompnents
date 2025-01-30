//
//  ImageExtension.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI
extension Image {
    //MARK: - customize Image
    func customizeImage(width: CGFloat,
                        height: CGFloat,
                        type color: Color,
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
