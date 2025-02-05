//
//  SignatureViewModel.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 05/02/2025.
//

import SwiftUI

@MainActor
class SignatureViewModel: ObservableObject {
    @Published var paths: [[CGPoint]] = []
    @Published var isDrawing: Bool = false

    func addPoint(_ point: CGPoint) {
        if paths.isEmpty || paths.last!.isEmpty {
            paths.append([])
        }
        paths[paths.count - 1].append(point)
    }

    func endPath() {
        paths.append([])
    }

    func clear() {
        paths.removeAll()
        isDrawing = false
    }

    func getSignatureDTO() -> SignatureDTO {
        return SignatureDTO(paths: paths)
    }
}

