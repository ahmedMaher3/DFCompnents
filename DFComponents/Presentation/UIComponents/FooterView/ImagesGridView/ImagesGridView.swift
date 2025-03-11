//
//  ImagesGridView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI
import PhotosUI

struct ImageGridView: View {
    @Binding var attachments: [AttachmentModel]
    @State private var showImageList = false
    let maxVisibleImages = 3

    var body: some View {
        NavigationStack {
            VStack {
                if !attachments.filter { $0.isImage }.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            let imageAttachments = attachments.filter { $0.isImage }
                            let visibleImages = Array(imageAttachments.prefix(maxVisibleImages))

                            ForEach(visibleImages) { attachment in
                                if let image = attachment.image {
                                    NavigationLink(destination: ImageListView(attachments: $attachments)) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .buttonStyle(PlainButtonStyle()) // Removes default navigation link styling
                                }
                            }

                            if imageAttachments.count > maxVisibleImages {
                                let remainingCount = imageAttachments.count - maxVisibleImages

                                NavigationLink(destination: ImageListView(attachments: $attachments)) {
                                    ZStack {
                                        Color.black.opacity(0.6)
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))

                                        Text("+\(remainingCount)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .bold))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle()) // Removes default navigation link styling
                            }
                        }
                    }
                    .frame(height: 100)
                }
            }
        }
    }
}
