//
//  FooterComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI
/*
struct FooterComponentView<ContentFooter: View>: View {
    let footerControlBaseProperties: () -> any InteractivePropertiesProtocol
    let content: () -> ContentFooter

    init(footerControlBaseProperties: @escaping () -> any InteractivePropertiesProtocol,
         @ViewBuilder content: @escaping () -> ContentFooter) {
        self.footerControlBaseProperties = footerControlBaseProperties
        self.content = content
    }

    var body: some View {
        content()
            .padding(4)
    }
}
*/

struct FooterComponentView<ContentFooter: View>: View {
    @ObservedObject var viewModel: FooterComponentViewModel
    let content: () -> ContentFooter
    init(viewModel: FooterComponentViewModel,
         @ViewBuilder content: @escaping () -> ContentFooter) {
        self.viewModel = viewModel
        self.content = content
    }
    var body: some View {
        content()
            .padding(4)
    }
}
