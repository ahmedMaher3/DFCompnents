//
//  StyleManager.swift
//  FormBuilder
//
//  Created by hassan elshaer on 11/02/2025.
//

import SwiftUI

struct StyleManager {
    // Colors
    var primaryTextColor: Color = AppColors.primaryText
    var secondaryTextColor: Color = AppColors.secondaryText
    var disabledTextColor: Color = AppColors.disabledText
    var borderColor: Color = AppColors.border
    var borderValidColor: Color = AppColors.borderValid
    var errorColor: Color = AppColors.error
    var disabledBackgroundColor: Color = AppColors.disabledBackground

    // Fonts
    var titleFont: Font = AppFonts.title
    var subtitleFont: Font = AppFonts.subtitle
    var errorFont: Font = AppFonts.error

    // Borders
    var borderWidth: CGFloat = AppBorders.width
    var cornerRadius: CGFloat = AppBorders.cornerRadius

    // Padding
    var componentPadding: CGFloat = AppSpacing.componentPadding
    var innerPadding: CGFloat = AppSpacing.innerPadding
}
