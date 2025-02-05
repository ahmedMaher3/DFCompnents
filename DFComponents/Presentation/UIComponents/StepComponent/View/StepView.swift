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
        HStack(spacing: 15) {
            VStack(spacing: 5) {
                Button(action: {
                    count += 1
                }) {
                    Image(systemName: "arrowtriangle.up.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }

                Button(action: {
                    if count > 0 {
                        count -= 1
                    }
                }) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 30))
                        .foregroundColor(count > 0 ? .blue : .gray)
                }
                .disabled(count == 0)
            }

            Text("\(count)")
                .font(.title)
                .fontWeight(.semibold)
               // .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)

        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    StepView()
}
