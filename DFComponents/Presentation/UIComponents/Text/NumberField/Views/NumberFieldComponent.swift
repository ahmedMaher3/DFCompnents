//
//  NumberFieldComponent.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct NumberFieldComponent: View {

    @EnvironmentObject var formViewModel:FormViewModel
    @StateObject var viewModel: NumberFieldViewModel

    init(viewModel: NumberFieldViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ContentNumberControlView(viewModel: viewModel)
            .environmentObject(formViewModel)
    }
}
