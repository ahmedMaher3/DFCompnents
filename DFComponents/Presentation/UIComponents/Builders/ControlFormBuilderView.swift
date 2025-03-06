//
//  ControlFormBuilderView.swift
//  DFComponents
//
//  Created by Eslam on 05/02/2025.
//

import SwiftUI

struct ControlFormBuilderView<Control: View, Header: View, Footer: View>: View {
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
            /// Header View (only shown if provided)
            headerView?()
            /// Control
            control()
            /// Warning Card (only if there's a warning)
            if let warning = warningMessage, !warning.isEmpty {
                WarningCardView(message: warning)
            }
            /// Footer View (only shown if provided)
            footerView?()
        }
    }
}
