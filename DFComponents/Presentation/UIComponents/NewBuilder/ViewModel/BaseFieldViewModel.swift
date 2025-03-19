//
//  BaseFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 17/03/2025.
//
import Foundation

final class BaseFieldViewModel: ObservableObject {
    @Published var errorMessage: String? = ""

    init(errorMessage: String = "") {
        self.errorMessage = errorMessage
    }
}
//final class BaseFieldViewModel: ObservableObject {
//    @Published var errorMessage: String?
//    private var cancellables = Set<AnyCancellable>()
//
//    init(field: any FieldRenderable) {
//        self.errorMessage = field.errorMessage
//        observeField(field)
//    }
//
//    private func observeField(_ field: any FieldRenderable) {
//        // Re-evaluate errorMessage when field.errorMessage changes
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in
//            DispatchQueue.main.async {
//                self?.errorMessage = field.errorMessage
//            }
//        }
//    }
//}
