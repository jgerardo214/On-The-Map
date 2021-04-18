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
    
    
    
}
