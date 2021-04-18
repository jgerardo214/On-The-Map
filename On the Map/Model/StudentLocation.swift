//
//  StudentLocation.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/24/21.
//

import Foundation

struct StudentLocation: Codable {
    
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: String
    let updatedAt: String
    
    
}

