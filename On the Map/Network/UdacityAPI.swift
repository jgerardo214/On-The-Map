//
//  UdacityAPI.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/25/21.
//

import Foundation

    
class UdacityAPI {
    
    struct Auth {
        static var keyAccount = ""
        static var sessionId = ""
    
    }
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case createSessionId
        case getStudentLocation(Int)
        case getOneStduentLocation(String)
        case postStudentLocation
        case updateStudentLocation(String)
        case getUserData
        case logout
        
        var urlString: String {
            switch self {
                
            case .createSessionId: return Endpoints.base + "session"
            case .getStudentLocation(let index): return Endpoints.base + "StudentLocation" + "?limit=100&skip=\(index)&order=-updatedAt"
            case .getOneStduentLocation(let uniqueKey): return Endpoints.base + "StudentLocation?uniqueKey=\(uniqueKey)"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .updateStudentLocation(let objectID): return Endpoints.base + "StudentLocation/\(objectID)"
            case .getUserData: return Endpoints.base + "users/" + Auth.keyAccount
            case .logout: return Endpoints.base + "session"
            }
            
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
 
    
    class func login(_ email: String,_ password: String, completion: @escaping (Bool, Error?)->()) {
            
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                    
              if error != nil { // Handle error…
                  return
              }
              let range = (5..<data!.count)
              let newData = data?.subdata(in: range) /* subset response data! */
              print(String(data: newData!, encoding: .utf8)!)
            }
            task.resume()
            
        }
        
        
        // TODO: create func to add Student location
        
        // TODO: create logout function
        
        //
        
        

        
        
        
    }
