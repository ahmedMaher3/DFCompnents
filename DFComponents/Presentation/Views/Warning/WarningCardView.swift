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
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)

            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .padding(.leading, 4)

            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}
