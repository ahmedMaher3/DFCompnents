//
//  WarningCardView.swift
//  DFComponents
//
//  Created by Eslam on 06/03/2025.
//
import SwiftUI

struct WarningCardView: View {
    let message: String

    var body: some View {
        HStack {
            Text(message)
                .font(.caption)
                .foregroundStyle(.red)
                .padding(.leading, 4)

            Spacer()
        }
    }
}
