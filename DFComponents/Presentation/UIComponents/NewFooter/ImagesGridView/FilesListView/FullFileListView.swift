//
//  FullFileListView.swift
//  DFComponents
//
//  Created by hassan elshaer on 19/03/2025.
//
import SwiftUI

// **Full File List View**
struct FullFileListView: View {
    @Binding var attachments: [AttachmentModel]
    @Environment(\.presentationMode) var presentationMode

    // Computed property to filter non-image attachments
    private var nonImageAttachments: [AttachmentModel] {
        attachments.filter { !$0.isImage }
    }

    var body: some View {
        VStack {
            // Header with "Files" and close button
            HStack(spacing: 12) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24, alignment: .leading)
                }

                Text("Files")
                    .font(.system(size: 18, weight: .medium)) // Adjusted font size
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.leading, 24) // Ensuring left padding is 24
            .padding(.trailing, 16) // Right padding for balance
            .padding(.top, 16)

            Divider()

            // File List
            List {
                ForEach(nonImageAttachments) { attachment in
                    FileRowView(attachment: attachment, attachments: $attachments)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}
