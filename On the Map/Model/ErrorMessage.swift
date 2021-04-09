//
//  ErrorMessage.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/8/21.
//

import Foundation

struct ErrorMessage {
    let message: String
    
}

extension ErrorMessage: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
