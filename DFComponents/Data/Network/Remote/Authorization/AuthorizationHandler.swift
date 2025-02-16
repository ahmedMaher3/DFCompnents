//
//  AuthorizationHandler.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/15/20.
//  Copyright © 2020 MaherOrganization. All rights reserved.
//

import Foundation

import Foundation

protocol AuthorizationHandler {
    var tokenHeader: [String: String] { get }
    var clientHeader: [String: String] { get }
    var uidHeader: [String: String] { get }
    var faceIdPhone: String { get }
    func setAuthManually(authToken: String)
    func setPhoneForFaceId(phone: String)
    func setClientManually(clientType: String)
    func setUidManually(uid: String)
    func removeAuthManually(authToken: String)
    func removeClientManually(client: String)
    func removeUidManually(uid: String)
}
