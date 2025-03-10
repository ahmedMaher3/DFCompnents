//
//  NumberFieldComponent.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct NumberFieldComponent: View {
    @EnvironmentObject var formViewModel:FormViewModel
    @ObservedObject var viewModel: NumberFieldViewModel

    var body: some View {
        ContentNumberControlView(viewModel: viewModel)
            .environmentObject(formViewModel)
    }
}
