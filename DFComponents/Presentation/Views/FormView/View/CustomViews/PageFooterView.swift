//
//  PageFooterView.swift
//  DFComponents
//
//  Created by ahmed maher on 19/03/2025.
//

import SwiftUI

struct PageFooterView: View {
    @Binding var currentPage: Int
    let totalPages: Int

    var body: some View {
        HStack {
            backButton
            Spacer()
            nextButton
        }
        .padding()
        .frame(height: 55)
        .background(Color(.systemGray6))
    }

    private var backButton: some View {
        Button(action: { currentPage -= 1 }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(currentPage > 0 ? .blue : .gray)
        }
        .disabled(currentPage == 0)
    }

    private var nextButton: some View {
        Button(action: { currentPage += 1 }) {
            HStack {
                Text("Next")
                Image(systemName: "chevron.right")
            }
            .foregroundColor(currentPage < totalPages - 1 ? .blue : .gray)
        }
        .disabled(currentPage >= totalPages - 1)
    }
}

