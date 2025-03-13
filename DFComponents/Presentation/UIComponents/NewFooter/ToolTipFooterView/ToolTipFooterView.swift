//
//  ToolTipFooterView.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/03/2025.
//

import SwiftUI

struct ToolTipFooterView: View {
    let tooltip: String
    @State private var showPopover = false

    var body: some View {
        if !tooltip.isEmpty {
            ZStack {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        showPopover.toggle()
                    }
                    .popover(isPresented: $showPopover, attachmentAnchor: .point(.center), arrowEdge: .top) {
                        tooltipPopover()
                            .frame(width: 250) // Set a fixed width to prevent truncation
                            .background(Color.gray)
                    }
            }
        }
    }

    @ViewBuilder
    private func tooltipPopover() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ScrollView { // Allow scrolling if the text is too long
                Text(tooltip)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true) // Prevent truncation
                    .padding()
            }
        }
        .background(Color.gray)
        .foregroundColor(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(width: 250) // Adjust width as needed
        .presentationCompactAdaptation(.popover)
    }
}
