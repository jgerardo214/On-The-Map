//
//  LoginRequest.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/27/21.
//

import Foundation

struct LoginRequest: Codable {
    
    let email: String
    let password: String
    
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let register: Bool
    let key: String?
}

struct Session: Codable {
    let id: String?
    let expiraton: String?
}
