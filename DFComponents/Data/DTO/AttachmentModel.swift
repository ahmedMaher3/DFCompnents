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
    
    var iconName: String? {
        guard image == nil else { return nil } // If it's an image, return nil (so UI can show actual image)
        
        switch fileType.lowercased() {
        case "pdf": return "pdfIcon"
        case "jpg", "jpeg", "png": return "photo"
        case "doc", "docx": return "officeIcon"
        case "ppt", "pptx": return "pdfIcon"
        case "xls", "xlsx": return "officeIcon"
        default: return "pdfIcon"
        }
    }
}

