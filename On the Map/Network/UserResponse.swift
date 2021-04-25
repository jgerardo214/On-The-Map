//
//  UserResponse.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/10/21.
//

import Foundation

struct UserResponse: Codable, Hashable {
    
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        
    }
    
}
