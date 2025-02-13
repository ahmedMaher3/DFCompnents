//
//  UserRepositoryImpl.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/02/2025.
//

import Foundation

final class UserRepositoryImpl: UserRepository {
    func getUsers() async throws -> [User] {
        return try await APIClient.shared.request(endpoint: UserAPI.getUsers)
    }

    func getUser(id: Int) async throws -> User {
        return try await APIClient.shared.request(endpoint: UserAPI.getUser(id: id))
    }
}
