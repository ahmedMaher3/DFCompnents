//
//  SectionView.swift
//  DFComponents
//
//  Created by ahmed maher on 04/02/2025.


import SwiftUI

struct SectionView: View {
    @StateObject private var viewModel = SectionViewModel()

    var body: some View {

        List (viewModel.sections) {  section in
            //ForEach(viewModel.sections) { section in
                Section(header: headerView(for: section)) {
                    if section.isExpanded {
                        ForEach(section.items, id: \.self) { item in
                            Text(item)
                                .padding(.vertical, 8)

                                .padding(.horizontal, 8)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
           // }
        }
        .listStyle(PlainListStyle())
    }

    // Custom header view with title and animated icon
    private func headerView(for section: SectionModel) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                viewModel.toggleSection(section)
            }
        }) {
            HStack {
                Text(section.title)
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(section.isExpanded ? 180 : 0))
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color(UIColor.systemGray5))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview
struct ExpandableSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView()
    }
}


