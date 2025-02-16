//
//  GuestAuthorization.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MaherOrganization. All rights reserved.
//


import Foundation

class NoneAuthorizationHandler: AuthorizationHandler {
   

    func setClientManually(clientType: String) {}
    func setUidManually(uid: String) {}
    func setAuthManually(authToken: String) {}
    func setPhoneForFaceId(phone: String){}
    var tokenHeader: [String: String] = [:]
    var clientHeader: [String: String] = [:]
    var uidHeader: [String: String] = [:]
    var faceIdPhone: String = ""
    func removeAuthManually(authToken: String){}
    func removeClientManually(client: String){}
    func removeUidManually(uid: String){}
}
