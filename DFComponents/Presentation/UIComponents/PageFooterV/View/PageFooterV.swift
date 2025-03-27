//
//  PageFooterV.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/23/25.
//

import SwiftUI

struct PageFooterV: View {
    
    @ObservedObject var viewModel: FooterViewModel
    
    init(viewModel: FooterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: viewModel.footerEntity.isExpanded ? 0 : 8) {
            if viewModel.footerEntity.isExpanded {
                Text(viewModel.footerEntity.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "#173E67"))
                    .lineLimit(2)
                
                Text(viewModel.footerEntity.description)
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
                    
                    if let iconURL = URL(string: self.viewModel.footerEntity.logo) {
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
                                        
                    Text(viewModel.footerEntity.title)
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
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#FAFBFF"))
    }
}

#Preview {
    let classicFooter = PageHeaderFooterEntity(logo: "", title: "", description: "", showQuestionsCount: true, isExpanded: true)
    PageFooterV(viewModel: FooterViewModel(footerEntity: classicFooter))
}
