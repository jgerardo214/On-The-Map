//
//  StudentInformation.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/23/21.
//

import Foundation

struct ResultsResponse: Codable {
    let results : [PostLocationResponse]

}

struct StudentInformation: Codable {
    
    let createdAt: String?
    let firstName: String
    let lastName: String
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let locationId: String
    let uniqueKey: String?
    let updatedAt: String?
    
    init( createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, objectId: String, locationId: String, uniqueKey: String, updatedAt: String) {
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.locationId = locationId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }
    
}
