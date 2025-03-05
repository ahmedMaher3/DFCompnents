//
//  ControlFormBuilderView.swift
//  DFComponents
//
//  Created by Eslam on 05/02/2025.
//

import SwiftUI
struct ControlFormBuilderView<Control: View>: View  {
    let titleControl: String
    let control: () -> Control

    //MARK: - inilize control
    init(titleControl: String, @ViewBuilder controlType: @escaping () -> Control) {
        self.titleControl = titleControl
        self.control = controlType
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            Text(titleControl)
                .fontWeight(.bold)
                .font(.system(size: 20))
            ///HeaderView
            ///Control
            control()
            ///FooterView
        }
    }
}

//struct ControlFormBuilderView<Control: View>: View {
//
////    let headerView: HeaderComponentView
//    let control: () -> Control
////    let footerView: FooterComponentView<<#ContentFooter: View#>>
//
//    //MARK: - inilize control
//    init(@ViewBuilder controlType: @escaping () -> Control) {
//        self.control = controlType
//    }
//
//    var body: some View {
//        LazyVStack(alignment: .leading, spacing: 8) {
//            ///HeaderView
//            ///Control
//            control()
//            ///FooterView
//        }
//    }
//}
