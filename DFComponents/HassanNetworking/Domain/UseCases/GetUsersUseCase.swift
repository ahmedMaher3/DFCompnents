//
//  GetUsersUseCase.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/02/2025.
//

import Foundation

final class GetUsersUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute() async throws -> [User] {
        return try await repository.getUsers()
    }
}
