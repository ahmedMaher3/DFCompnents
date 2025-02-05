//
//  SignatureCanvasView.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 05/02/2025.
//

import SwiftUI

struct SignatureCanvasView: View {
    @ObservedObject var viewModel: SignatureViewModel

    var body: some View {
        Canvas { context, size in
            for path in viewModel.paths {
                var line = Path()
                line.addLines(path)
                context.stroke(line, with: .color(.black), lineWidth: 2)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    viewModel.isDrawing = true
                    viewModel.addPoint(value.location)
                }
                .onEnded { _ in
                    viewModel.endPath()
                }
        )
    }
}

#Preview {
    SignatureCanvasView(viewModel: SignatureViewModel())
}
