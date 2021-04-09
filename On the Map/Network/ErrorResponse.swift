//
//  ErrorResponse.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/8/21.
//

import Foundation

struct ErrorResponse: Codable {
    
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
