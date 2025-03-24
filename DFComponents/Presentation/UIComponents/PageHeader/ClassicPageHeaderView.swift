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
            VStack(alignment: .leading, spacing: viewModel.headerData.isExpanded ? 0 : 8) {
                if viewModel.headerData.isExpanded {
                    Text(viewModel.headerData.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "#173E67"))
                        .lineLimit(2)
                        .padding(.bottom, 6)

                    Text(viewModel.headerData.description)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#173E67"))
                        .lineLimit(5)
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            withAnimation {
                                self.viewModel.toggleExpanded()
                            }
                        }

                } else {
                    HStack(spacing: 8) {
                        if let iconURL = URL(string: self.viewModel.headerData.logo) {
                            AsyncImage(url: iconURL) { image in
                                image.resizable()
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color(hex: "#173E67"))
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image("info.circle.fill")
                                .foregroundColor(Color(hex: "#173E67"))
                        }

                        Text(viewModel.headerData.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "#173E67"))
                            .lineLimit(1)
                    }
                    .onTapGesture {
                        withAnimation {
                            self.viewModel.toggleExpanded()
                        }
                    }
                }
            }
            .padding([.top, .leading, .trailing])
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#FAFBFF"))

            Divider()
                .frame(height: 1)
                .background(Color.gray)
                .padding(.bottom, 4)
        }
    }
}

/*
 #Preview {
 ClassicPageHeaderView()
 }
 */
