//
//  SectionView.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import SwiftUI

struct SectionView: View {
    
    @ObservedObject var sectionViewModel: SectionViewModel
    @EnvironmentObject var viewModel: FormViewModel
    
    @State private var isExpanded: Bool = false
    
    init(sectionViewModel: SectionViewModel, isExpanded: Bool) {
        self.sectionViewModel = sectionViewModel
       // self.fields = sectionViewModel.controls
        self.isExpanded = isExpanded
    }
    
    var body: some View {
        Section(header: sectionHeader().frame(height: 70)) {
            if isExpanded {
                ScrollView {
//                    LazyVStack(spacing: 10) {
//                        ForEach(self.sectionViewModel.controls, id: \.id) { field in
//                            renderField(for: field)
//                        }
//                    }
                }
            }
        }
        .listRowInsets(EdgeInsets())
    }
    
    // MARK: - Section Header
    @ViewBuilder
    private func sectionHeader() -> some View {
        VStack {
            Button(action: {
                isExpanded.toggle()
                self.sectionViewModel.sectionField.isExpandedStatus = isExpanded
            }) {
                HStack {
                    
                    if let iconURLString = self.sectionViewModel.sectionField.icon, let iconURL = URL(string: iconURLString) {
                        AsyncImage(url: iconURL) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image("Business")
                            .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                    }
                    Text(sectionViewModel.sectionField.label)
                        .font(.headline)
                        .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(isExpanded ? Color(hex: "#E6EDFD") : Color(hex: "#5989EF"))
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(isExpanded ? Color(hex: "#5989EF") : Color(hex: "#E6EDFD"))
            }
        }
    }
//
//    @ViewBuilder
//    private func renderField(for field:  any FieldRenderable) -> some View {
//        BaseFieldContainerView(
//            field: field
//        )
//        //.opacity(radioViewModel.control.hidden ? 0 : 1)
//
//    }
}
