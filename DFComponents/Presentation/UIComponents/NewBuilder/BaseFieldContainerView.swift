//
//  BaseFieldContainerView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI
import Combine
/*
final class ErrorMessageHandler: ObservableObject {
    @Published var errorMessage: String?

    init(field: any FieldRenderable) {
        self.errorMessage = field.errorMessage
    }

    func updateErrorMessage(_ newMessage: String?) {
        Task { @MainActor in
            self.errorMessage = newMessage
        }
    }
}
struct BaseFieldContainerView: View {
    let field: any FieldRenderable
    @StateObject private var errorHandler: ErrorMessageHandler

    init(field: any FieldRenderable) {
        self.field = field
        _errorHandler = StateObject(wrappedValue: ErrorMessageHandler(field: field))
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            /// Header View
            field.renderHeader()

            /// Control with overlay for warnings
            field.render()

            /// Footer View
            BaseFooterControlView(viewModel: BaseFooterViewModel(control: field))
                .frame(maxWidth: .infinity, alignment: .leading)

            /// Warning View
            WarningCardView(message: errorHandler.errorMessage ?? "")
                .opacity(errorHandler.errorMessage?.isEmpty == false ? 1 : 0)
        }
        .padding(6)
        .background(errorHandler.errorMessage?.isEmpty == false ? Color.red.opacity(0.05) : Color.clear)
        .cornerRadius(8)
        .onReceive(Just(field.errorMessage)) { newMessage in
            errorHandler.updateErrorMessage(newMessage)
        }
    }
}
*/

struct BaseFieldContainerView: View {
    let field: any FieldRenderable
    @StateObject var viewModel: BaseFieldViewModel = BaseFieldViewModel()
    @State private var lastErrorMessage: String?

    init(field: any FieldRenderable) {
        self.field = field
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            /// Header View
            BaseHeaderControlView(viewModel: BaseHeaderViewModel(field: field))

            /// Control with overlay for warnings
            field.render()

            /// Footer View - Aligned to Control
            BaseFooterControlView(viewModel: BaseFooterViewModel(control: field))
                .frame(maxWidth: .infinity, alignment: .leading)

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
