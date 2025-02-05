//
//  SignatureComponent.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 03/02/2025.
//
import SwiftUI

struct SignatureView: View {
    @ObservedObject var viewModel: SignatureViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What is your name?")
                .font(.headline)
                .foregroundColor(.black)

            ZStack {
                // Background Box
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(height: 200)
                    .background(Color.white)

                // Placeholder (Visible when not drawing)
                if !viewModel.isDrawing {
                    VStack {
                        Image(systemName: "scribble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.blue)

                        Text("Sign Here")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                }

                // Signature Canvas
                SignatureCanvasView(viewModel: viewModel)
                    .frame(height: 200)

                // Trash Icon (Only when user starts drawing)
                if viewModel.isDrawing {
                    Button(action: {
                        viewModel.clear()
                    }) {
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.red)
                    }
                    .offset(x: 120, y: -80)
                    
                }
            }
        }
        .padding()
    }
}
#Preview {
    SignatureView(viewModel: SignatureViewModel())
}
