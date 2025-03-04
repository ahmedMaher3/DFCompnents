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
        ///HeaderView
        ///Content Control
        ContentNumberControlView(viewModel: viewModel)
        ///FooterView
    }
}

