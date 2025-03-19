//
//  BaseFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 17/03/2025.
//
import Combine
import Foundation

final class BaseFieldViewModel: ObservableObject {
    @Published var errorMessage: String? = ""

    private var cancellables = Set<AnyCancellable>()

    func bindErrorMessage(_ publisher: Published<String?>.Publisher) {
        publisher
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
            .removeDuplicates() // Prevent unnecessary updates
            .sink { [weak self] newError in
                self?.errorMessage = newError ?? ""
                print("Updated error message: \(newError ?? "nil")")
            }
            .store(in: &cancellables)
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
