//
//  StepView.swift
//  DFComponents
//
//  Created by ahmed maher on 05/02/2025.
//

import SwiftUI

struct StepView: View {
    @State private var count: Int = 0

    var body: some View {
        HStack(spacing: 20) {
            // Minus Button
            Button(action: {
                if count > 0 {
                    count -= 1
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(count > 0 ? .red : .gray)
            }
            .disabled(count == 0)

            // Count Label
            Text("\(count)")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.vertical, 5)
                .padding(.horizontal, 30)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)

            Button(action: {
                count += 1
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    StepView()
}
