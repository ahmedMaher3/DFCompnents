//
//  ControlFormBuilderView.swift
//  DFComponents
//
//  Created by Eslam on 05/02/2025.
//

import SwiftUI

struct ControlFormBuilderView<Header: View, Control: View, Footer: View>: View {
    let headerView: (() -> Header)?
    let control: () -> Control
    let footerView: (() -> Footer)?
    @Binding var warningMessage: String?

    init(@ViewBuilder headerView: @escaping () -> Header,
         @ViewBuilder controlType: @escaping () -> Control,
         @ViewBuilder footerView: @escaping () -> Footer,
         warningMessage: Binding<String?>) {
        self.headerView = headerView
        self.control = controlType
        self.footerView = footerView
        self._warningMessage = warningMessage
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            /// Header View
            headerView?()
            /// Control
            control()
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(warningMessage != nil ? .red : .clear, lineWidth: 0.5))

            /// Footer View
            footerView?()
            
            /// Warning Message (No View Rebuild)
            WarningCardView(message: warningMessage ?? "")
                .opacity(warningMessage == nil ? 0 : 1)
        }
        .padding(6)
        .background(warningMessage == nil ? Color.clear : Color.red.opacity(0.05))
        .cornerRadius(8)
    }
}
