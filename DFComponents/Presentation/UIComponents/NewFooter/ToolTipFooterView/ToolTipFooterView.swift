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
                Image(.pinToolTip)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        showPopover.toggle()
                    }
                    .popover(isPresented: $showPopover, attachmentAnchor: .point(.center), arrowEdge: .top) {
                        tooltipPopover()
                    }
            }
        }
    }

    @ViewBuilder
    private func tooltipPopover() -> some View {
        ZStack {
            Color.primaryBlue
                .clipShape(RoundedRectangle(cornerRadius: 12))

            ScrollView {
                Text(tooltip)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(nil) // Allow scrolling for overflow text
                    .padding(4)
            }
            .frame(maxHeight: 60) // Adjust based on font size (~4 lines)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(Color.primaryBlue)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    ToolTipFooterView(tooltip: "test test test testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest test")
}
