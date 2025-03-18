//
//  PageView.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import SwiftUI

struct PageView: View {

    @EnvironmentObject var viewModel: FormViewModel
    @ObservedObject var pageViewModel: PageViewModel

    init(pageViewModel: PageViewModel) {
        self.pageViewModel = pageViewModel
    }

    var body: some View {

        if self.viewModel.mode == .classic {
            List {
                ForEach(self.pageViewModel.controls, id: \.id) { field in
                    renderField(for: field)
                        .environmentObject(viewModel)
                }
            }
            .buttonStyle(PlainButtonStyle()) // to make all button actions work properly within a list
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it fills space
        } else {

            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Spacer()
                        ForEach(self.pageViewModel.controls, id: \.id) { field in
                            renderField(for: field)
                                .frame(maxWidth: .infinity)
                                .environmentObject(viewModel)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height) // Uses container height
                }
            }

        }
    }


    @ViewBuilder
    private func renderField(for field:  FieldRenderable) -> some View {
        BaseFieldContainerView(
            field: field

        )
        //.opacity(radioViewModel.control.hidden ? 0 : 1)

    }


}

