//
//  FilesListView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//
import SwiftUI

struct FileListView: View {
    @Binding var attachments: [AttachmentModel]
    @State private var showFileList = false

    var body: some View {
        let nonImageAttachments = attachments.filter { !$0.isImage }
        let maxVisibleFiles = 3
        let remainingCount = max(0, nonImageAttachments.count - maxVisibleFiles)

        if !nonImageAttachments.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(nonImageAttachments.prefix(maxVisibleFiles))) { attachment in
                    FileRowView(attachment: attachment, attachments: $attachments)
                }

                // Show More Button to Open Full List
                if remainingCount > 0 {
                    Button(action: {
                        showFileList.toggle()
                    }) {
                        Text("Show (\(remainingCount)) more files")
                            .font(.body)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                    .sheet(isPresented: $showFileList) {
                        FullFileListView(attachments: $attachments)
                    }
                }
            }
        }
    }
}

