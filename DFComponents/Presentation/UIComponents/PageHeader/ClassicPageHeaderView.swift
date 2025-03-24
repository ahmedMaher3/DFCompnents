//
//  ClassicPageHeaderView.swift
//  DFComponents
//
//  Created by Eslam on 24/03/2025.
//

import SwiftUI

struct ClassicPageHeaderView: View {
    @ObservedObject var viewModel: ClassicPageHeaderViewModel

    var body: some View {
        VStack {
            contentView
                .onTapGesture {
                    withAnimation {
                        viewModel.toggleExpanded()
                    }
                }
                .padding([.top, .leading, .trailing])
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#FAFBFF"))

            Divider()
                .frame(height: 1)
                .background(Color.gray)
                .padding([.top,.bottom], 4)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.headerData.isExpanded {
            expandedView
        } else {
            collapsedView
        }
    }

    /// Expanded View
    private var expandedView: some View {
        HStack(alignment: .top, spacing: 12) {
            if let iconURL = URL(string: viewModel.headerData.logo) {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                        .frame(width: 20, height: 20)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.primaryBlue)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.headerData.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.primaryBlue)
                    .lineLimit(2)

                Text(viewModel.headerData.description)
                    .font(.system(size: 14))
                    .foregroundStyle(.primaryBlue)
                    .lineLimit(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    /// Collapsed View
    private var collapsedView: some View {
        HStack(spacing: 8) {
            if let iconURL = URL(string: viewModel.headerData.logo) {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                        .frame(width: 20, height: 20)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.primaryBlue)
            }

            Text(viewModel.headerData.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.primaryBlue)
                .lineLimit(1)
        }
    }
}

/*
 #Preview {
 ClassicPageHeaderView()
 }
 */
