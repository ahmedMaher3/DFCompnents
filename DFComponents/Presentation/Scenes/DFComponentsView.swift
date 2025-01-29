//
//  DFComponentsView.swift
//  DFComponents
//
//  Created by ahmed maher on 29/01/2025.
//

import SwiftUI

struct DFComponentsView: View {
    @StateObject var viewModel: DropDownViewModel = DropDownViewModel()

    var body: some View {
        List {
            DropDownView(title: "Select Country", viewModel: viewModel )
                .listRowSeparator(.hidden)
   
        }
        .listRowSeparator(.hidden)
        .listStyle(PlainListStyle())

    }
}

#Preview {
    DFComponentsView()
}
