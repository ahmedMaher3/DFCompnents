//
//  FileRow.swift
//  DFComponents
//
//  Created by hassan elshaer on 19/03/2025.
//

import SwiftUI

// **File Row View**
struct FileRowView: View {
    let attachment: AttachmentModel
    @Binding var attachments: [AttachmentModel]

    var body: some View {
        HStack {
            // File Type Icon
            Image(attachment.iconName ?? "pdfIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .padding(.trailing, 8)

            // File Info
            VStack(alignment: .leading, spacing: 4) {
                Text(attachment.fileName)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(formatFileSize(attachment.fileSize))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Delete Button
            Button(action: {
                if let index = attachments.firstIndex(where: { $0.id == attachment.id }) {
                    attachments.remove(at: index)
                }
            }) {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(red: 220/255, green: 220/255, blue: 220/255), lineWidth: 1) // Light gray border
        )
        .background(Color.clear) // Transparent background
    }

    // Function to format file size dynamically
    private func formatFileSize(_ size: Int) -> String {
        let kb = Double(size) / 1024
        if kb < 1024 {
            return String(format: "%.1f KB", kb)
        } else {
            return String(format: "%.1f MB", kb / 1024)
        }
    }
}
