//
//  LoginRequest.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/30/21.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
}

struct Udacity:Codable {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
