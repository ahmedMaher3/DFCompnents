//
//  NumberFieldComponent.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct NumberFieldComponent: View {

    @StateObject var viewModel: NumberFieldViewModel

    init(viewModel: NumberFieldViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            /// Header View
            HeaderComponentView(viewModel: HeaderComponentViewModel(baseProperties: viewModel.baseProperties!))
                .padding(.bottom, 8)

            ///Content Control & Contain Warning
            ContentNumberControlView(viewModel: viewModel)

            /// Footer View
            if let interactiveProperties = viewModel.interactiveProperties {
                FooterComponentView(viewModel: FooterComponentViewModel(interactiveBaseProperties: viewModel.interactiveProperties!.base)) {
                    HStack {
                        Text(interactiveProperties.addNote == true ? "Note": "")
                        Text(interactiveProperties.addAttachment == true ? "|| Attachment": "")
                    }
                }
//                FooterComponentView(
//                    footerControlBaseProperties: { interactiveProperties },
//                    content: {
//                        HStack {
//                            Text(interactiveProperties.addNote == true ? "Note": "")
//                            Text(interactiveProperties.addAttachment == true ? "|| Attachment": "")
//                        }
//                    }
//                )
            }
        }
    }
}
