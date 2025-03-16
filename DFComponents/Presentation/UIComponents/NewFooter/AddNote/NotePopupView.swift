//
//  noteViewPopup.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI

struct NotePopupView: View {
    @Binding var noteText: String
    var onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isTextEditorFocused: Bool  // Focus state for TextEditor

    var body: some View {
        VStack {
            // Custom header with title and buttons
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.blue)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text("Add Note")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading, 8)

                Spacer()

                Button(action: {
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(Color.white)
            
            // Divider line under the title
            Divider()
                .background(Color.gray.opacity(0.5))
            
            // Note TextEditor with auto-focus
            TextEditor(text: $noteText)
                .focused($isTextEditorFocused) // Bind focus state
                .frame(maxHeight: .infinity)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight]) // Apply corner radius to the top
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextEditorFocused = true // Auto-focus on appear
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

//// Custom corner radius modifier for specific corners
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
