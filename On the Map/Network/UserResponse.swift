//
//  UserResponse.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/10/21.
//

import Foundation

struct UserResponse: Codable {
    
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}
