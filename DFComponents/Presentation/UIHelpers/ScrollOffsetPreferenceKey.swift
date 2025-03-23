//
//  ScrollOffsetPreferenceKey.swift
//  DFComponents
//
//  Created by Eslam on 23/03/2025.
//
import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
