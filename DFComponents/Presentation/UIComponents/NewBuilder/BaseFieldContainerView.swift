//
//  BaseFieldContainerView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI

struct BaseFieldContainerView: View {
    let field: BaseFieldProtocol
    let content: FieldRenderable

    init(
        field:  BaseFieldProtocol,
        content:  FieldRenderable
    )
    {
        self.field = field
        self.content = content
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            /// Header View
           // BaseHeaderControlView(viewModel: BaseHeaderViewModel(field: field))

            /// Control with overlay for warnings
            content.render(field: field)
            //

//             Footer View - Aligned to Control
//            BaseFooterControlView(viewModel: BaseFooterViewModel(control: field))
//                            .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
//                            .padding(.leading, 0) // Adjust leading padding as needed to match the control

            /// Warning View
            WarningCardView(message: viewModel.errorMessage ?? "")
                .opacity(viewModel.errorMessage == nil ? 0 : 1)
        }
        .padding(6)
        .background(field.errorMessage == nil || field.errorMessage == "" ? Color.clear : Color.red.opacity(0.05))
        .cornerRadius(8)
        .onReceive(Just(field.errorMessage)) { errorMessage in
            Task { @MainActor in
                print("Display please error message:\(errorMessage ?? "nil")")
//                viewModel.errorMessage = errorMessage ?? ""
            }
        }
    }
}

/*
 .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
 let newErrorMessage = field.errorMessage
 if viewModel.errorMessage != newErrorMessage, newErrorMessage != lastErrorMessage {
 viewModel.errorMessage = newErrorMessage
 lastErrorMessage = newErrorMessage
 print("✅ Updated error message: \(newErrorMessage ?? "nil")")
 }
 }
 //        .onReceive(viewModel.$errorMessage) { newErrorMessage in
 //                   // Update the error message in ViewModel only when it changes
 //            Task { @MainActor in
 //                if viewModel.errorMessage != newErrorMessage {
 //                    viewModel.errorMessage = newErrorMessage
 //                    print("✅ Updated error message: \(newErrorMessage ?? "nil")")
 //                }
 //            }
 //        }
 */
