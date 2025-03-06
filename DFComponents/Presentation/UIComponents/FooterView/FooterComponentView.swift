//
//  FooterComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct FooterComponentView: View {
    @StateObject var viewModel: FooterComponentViewModel

    init(viewModel: FooterComponentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        renderFooter(for: viewModel.interactiveProperties)
            .padding(4)
    }
    
    /// FooterView
    @ViewBuilder
    private func renderFooter(for interactiveProperties: InteractiveField?) -> some View {
        if let interactiveProperties = interactiveProperties {
            if interactiveProperties.addNote || interactiveProperties.addAttachment {
                HStack {
                    if interactiveProperties.addNote {
                        Text("Note")
                    }
                    if interactiveProperties.addAttachment {
                        Text("|| Attachment")
                    }
                }
            } else {
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }
}
