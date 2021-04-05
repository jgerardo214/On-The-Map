//
//  PostLocation.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/4/21.
//

import Foundation

struct PostLocation: Codable {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    
    
}
