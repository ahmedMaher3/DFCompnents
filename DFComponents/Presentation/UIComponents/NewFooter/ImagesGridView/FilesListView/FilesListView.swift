//
//  FilesListView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI

struct FileListView: View {
    @Binding var attachments: [AttachmentModel]
    @State private var showAllFiles = false

    var body: some View {
        let nonImageAttachments = attachments.filter { !$0.isImage }
        let maxVisibleFiles = 3
        let remainingCount = max(0, nonImageAttachments.count - maxVisibleFiles)

        if !nonImageAttachments.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(showAllFiles ? nonImageAttachments : Array(nonImageAttachments.prefix(maxVisibleFiles))) { attachment in
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
                            attachments.removeAll { $0.id == attachment.id }
                        }) {
                            Image(.delete)
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

                // Show More / Show Less Button
                if remainingCount > 0 {
                    Button(action: {
                        withAnimation {
                            showAllFiles.toggle()
                        }
                    }) {
                        Text(showAllFiles ? "Show less" : "Show \(remainingCount) more files")
                            .font(.body)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                }
            }
        }
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
