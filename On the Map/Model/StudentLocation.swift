//
//  StudentLocation.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/24/21.
//

import Foundation

struct StudentLocation: Codable {
    
    static var lastFeched: [StudentLocation]?
    var createdAt: String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
    
    
}

