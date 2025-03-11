//
//  BaseParentField.swift
//  DFComponents
//
//  Created by hassan elshaer on 10/03/2025.
//

import SwiftUI

struct TooltipView: View {
    let text: String
    let width: CGFloat
    @Binding var isVisible: Bool

    var body: some View {
        if isVisible {
            VStack(spacing: 0) {
                Text(text)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: width)
                    .background(Color.gray)
                    .cornerRadius(8)
                    .shadow(radius: 4)

                Triangle()
                    .fill(Color.gray)
                    .frame(width: 15, height: 10)
            }
            .transition(.opacity)
        }
    }
}

// Custom triangle shape for tooltip arrow
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


struct ContentView_toolTip: View {
    @State private var showTooltip = false

    var body: some View {
        HStack {
            Text("Provide a brief summary of the inspection findings, including any concerns")
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()

            ZStack {
                Button(action: {
                    withAnimation {
                        showTooltip.toggle()
                    }
                }) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                }

                TooltipView(text: "Your Minimum Characters is 10 & Maximum is 20.",
                            width: 200,
                            isVisible: $showTooltip)
                .offset(y: -40) // Position tooltip above the icon
            }

            Text("0/10")
                .foregroundColor(.gray)
                .font(.body)
        }
        .padding()
    }
}

//#Preview {
//    ContentView_toolTip()
//}

import SwiftUI

struct AddNoteView: View {
    @State private var noteText: String = ""
    @State private var savedNote: String? = nil
    @State private var showNotePopup = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What is your Name ?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            TextField("Lorem ipsum dolor", text: .constant(""))
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .disabled(true)

            Text("Lorem ipsum dolor sit amet, consectetur")
                .foregroundColor(.primary)

            HStack {
                Button(action: { showNotePopup.toggle() }) {
                    Image(systemName: "bubble.left.and.text.bubble.right.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }

                Button(action: {
                    // Handle attachment action here
                }) {
                    Image(systemName: "paperclip")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }

            if let note = savedNote {
               Text(note)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .sheet(isPresented: $showNotePopup) {
            NotePopupView(noteText: $noteText, onSave: {
                savedNote = noteText
                showNotePopup = false
            })
            .presentationDetents([.large])
            .presentationCornerRadius(20) // Add corner radius to the sheet
        }
    }
}

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


// Custom corner radius modifier for specific corners
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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}

import SwiftUI

struct ExpandableNoteView: View {
    let text: String
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .lineLimit(isExpanded ? nil : 2) // Show 2 lines when collapsed
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.clear)
                .cornerRadius(8)

            if text.count > 100 { // Show "More" only if text is long
                Button(action: { isExpanded.toggle() }) {
                    Text(isExpanded ? "Show Less" : "More")
                        .foregroundColor(.blue)
                        .font(.footnote)
                        .padding(.leading, 8)
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            ExpandableNoteView(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        }
        .padding()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
