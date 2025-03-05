//
//  FooterComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI
struct FooterComponentView<ContentFooter: View>: View {
    let footerControlBaseProperties: () -> any InteractivePropertiesProtocol
    let content: () -> ContentFooter

    init(footerControlBaseProperties: @escaping () -> any InteractivePropertiesProtocol,
         @ViewBuilder content: @escaping () -> ContentFooter) {
        self.footerControlBaseProperties = footerControlBaseProperties
        self.content = content
    }

    var body: some View {
        HStack(spacing: 4) {
            content()
        }
        .padding(4)
    }
}
