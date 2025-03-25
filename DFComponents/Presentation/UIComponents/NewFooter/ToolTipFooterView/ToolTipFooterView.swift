//
//  ToolTipFooterView.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/03/2025.
//

import SwiftUI

struct ContentLengthPreference: PreferenceKey {
    static var defaultValue: CGFloat { 0 }

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ToolTipFooterView: View {
    let tooltip: String
    @State private var showPopover = false
    @State var textHeight: CGFloat = 0

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
                    .popover(isPresented: $showPopover,
                             attachmentAnchor: .point(.top),
                             arrowEdge: .bottom) {
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
            Text(tooltip)
                .font(.system(size: 12))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(nil) // Allow scrolling for overflow text
                .padding(4)
                .overlay(
                    GeometryReader { proxy in
                        Color
                            .clear
                            .preference(key: ContentLengthPreference.self,
                                        value: proxy.size.height)
                    }
                )
                .onPreferenceChange(ContentLengthPreference.self) { value in
                    Task { @MainActor in
                        self.textHeight = value
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: textHeight)
                .padding()
                .presentationCompactAdaptation(.none)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(Color.primaryBlue)

    }
}

#Preview {
    ToolTipFooterView(tooltip: "test test")
}
