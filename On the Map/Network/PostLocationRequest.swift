//
//  PostLocationRequest.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/10/21.
//

import Foundation

struct PostLocationRequest: Codable {
    let accountKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
