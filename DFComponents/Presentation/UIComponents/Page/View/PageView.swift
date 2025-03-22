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

    var body: some View {
        Group {
            if viewModel.mode == .classic {
                PageListView(controls: pageViewModel.controls, showFooter: pageViewModel.showFooter, classicPageFooter: pageViewModel.pageFooter)
            } else {
                PageScrollView(controls: pageViewModel.controls)
            }
        }
        .environmentObject(viewModel)
    }
}

// MARK: - Page Layouts

/// List-based layout for `.classic` mode
private struct PageListView: View {
    let controls: [FieldEntity]
    let showFooter: Bool
    let classicPageFooter: PageFooterEntity
    
    init(controls: [FieldEntity], showFooter: Bool, classicPageFooter: PageFooterEntity) {
        self.controls = controls
        self.showFooter = showFooter
        self.classicPageFooter = classicPageFooter
    }

    var body: some View {
        List {
            ForEach(controls, id: \.id) { field in
                FieldRenderer(field: field)
            }
            if showFooter {
                Section {
                    PageFooterV(viewModel: FooterViewModel(footerData: classicPageFooter))
                        .listRowInsets(EdgeInsets())
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#FAFBFF"))
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Ensure buttons work within the List
        .listStyle(PlainListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// ScrollView-based layout for `.card` mode
private struct PageScrollView: View {
    let controls: [FieldEntity]

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(controls, id: \.id) { field in
                        FieldRenderer(field: field)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                .padding()
            }
        }
    }
}

