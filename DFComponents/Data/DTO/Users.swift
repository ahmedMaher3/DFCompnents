//
//  Users.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/02/2025.
//

import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let name: String
    let email: String
}
