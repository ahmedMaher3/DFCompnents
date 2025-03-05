//
//  FooterComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

//struct FooterComponentView<InteractiveProperties: InteractivePropertiesProtocol>: View {
//    ///InteractiveProperties
//    @ObservedObject var viewModel: FooterComponentViewModel<InteractiveProperties>
//
//    init(viewModel: FooterComponentViewModel<InteractiveProperties>) {
//        self.viewModel = viewModel
//    }
//    /// InteractiveProperties
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
/*
struct FooterComponentView<BaseComponentProperties: InteractivePropertiesProtocol>: View {
    let footerControlBaseProperties: () -> BaseComponentProperties
    let content: () -> AnyView

    init(
        @ViewBuilder footerControlBaseProperties: @escaping () -> BaseComponentProperties,
        @ViewBuilder content: @escaping () -> AnyView
    ) {
        self.footerControlBaseProperties = footerControlBaseProperties
        self.content = content
    }

    var body: some View {
        VStack {
            if let label = footerControlBaseProperties().label {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            content()
        }
    }
}
*/
//struct FooterComponentView<BaseComponentProperties: InteractivePropertiesProtocol>: View {
//    let footerControlBaseProperties: () -> BaseComponentProperties
//    let content: () -> AnyView
//
//    init(
//        footerControlBaseProperties: @escaping () -> BaseComponentProperties,
//        @ViewBuilder content: @escaping () -> AnyView
//    ) {
//        self.footerControlBaseProperties = footerControlBaseProperties
//        self.content = content
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            if let label = footerControlBaseProperties().label {
//                Text(label)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            content()
//        }
//        .padding(.top, 4)
//    }
//}
//

struct FooterComponentView<ContentFooter: View>: View {
    let footerControlBaseProperties: () -> any InteractivePropertiesProtocol
    let content: () -> ContentFooter

    init(
        footerControlBaseProperties: @escaping () -> any InteractivePropertiesProtocol,
        @ViewBuilder content: @escaping () -> ContentFooter
    ) {
        self.footerControlBaseProperties = footerControlBaseProperties
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let note = footerControlBaseProperties().addNote,
               note == true {
                Text("AddNote")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            content()
        }
    }
}
