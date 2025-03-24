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
    var onScroll: ((CGFloat) -> Void)?
    @Binding var headerVisible: Bool

    var body: some View {
        pageContent
            .environmentObject(viewModel)
    }

    @ViewBuilder
    private var pageContent: some View {
        if viewModel.mode == .classic {
            PageListView(
                controls: pageViewModel.controls,
                showFooter: pageViewModel.showFooter,
                classicPageFooter: pageViewModel.pageFooter,
                headerVisible: $headerVisible,
                onScroll: onScroll
            )
        } else {
            PageScrollView(
                controls: pageViewModel.controls,
                headerVisible: $headerVisible,
                onScroll: onScroll
            )
        }
    }
}

// MARK: - Page Layouts
/// List-based layout for `.classic` mode
private struct PageListView: View {
    let controls: [FieldEntity]
    let showFooter: Bool
    let classicPageFooter: PageFooterEntity
    @Binding var headerVisible: Bool

    var onScroll: ((CGFloat) -> Void)?

    var body: some View {
        ScrollView {
            GeometryReader { proxy in
                Color.clear
                    .frame(height: 0)
                    .preference(key: ScrollOffsetPreferenceKey.self,
                                value: proxy.frame(in: .named("scrollView")).minY)
                    .onChange(of: proxy.frame(in: .named("scrollView")).minY) { _, newValue in
                        headerVisible = newValue > -50
                        onScroll?(newValue)
                    }
            }
            .frame(height: 0)
            LazyVStack {
                ForEach(controls, id: \.id) { field in
                    FieldRenderer(field: field)
                }
            }
            if showFooter {
                PageFooterV(viewModel: FooterViewModel(footerData: classicPageFooter))
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#FAFBFF"))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .listStyle(PlainListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // allowing other views (such as GeometryReader or .preference) to measure positions relative to that space instead of the default global or local coordinate system
        .coordinateSpace(name: "scrollView")
    }
}

/// ScrollView-based layout for `.card` mode
private struct PageScrollView: View {
    let controls: [FieldEntity]
    @Binding var headerVisible: Bool
    var onScroll: ((CGFloat) -> Void)?

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
