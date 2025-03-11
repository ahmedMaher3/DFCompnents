//
//  AttachmentsModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import Foundation
import SwiftUI

// MARK: - Attachment Model
struct AttachmentModel: Identifiable {
    let id = UUID()
    let fileName: String
    let fileSize: Int
    let fileType: String
    var image: UIImage? = nil
    
    var isImage: Bool {
        return image != nil
    }
    
    var iconName: String {
        switch fileType.lowercased() {
        case "pdf": return "doc.richtext"
        case "jpg", "jpeg", "png": return "photo"
        case "doc", "docx": return "doc.text"
        case "ppt", "pptx": return "doc.on.clipboard"
        case "xls", "xlsx": return "tablecells"
        default: return "doc"
        }
    }
}
