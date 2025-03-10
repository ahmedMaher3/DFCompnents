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
          HStack(alignment: .center) {
          //    Image(systemName: "xmark.circle.fill")

              Text(message)
                  .font(.caption)
                  .padding(.leading, 4)
          }
          .foregroundStyle(.red)
      }
}
#Preview {
    WarningCardView(message: "Eslam")
}
