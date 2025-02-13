//
//  UserRepository.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/02/2025.
//

import Foundation

protocol UserRepository {
    func getUsers() async throws -> [User]
    func getUser(id: Int) async throws -> User
}
