//
//  UdacityAPI.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/25/21.
//

import Foundation
import UIKit



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
    
    
    
    
    
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> ()) {
        
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            func showError(_ error: String){
                print(error)
            }
            guard (error == nil) else {
                completion (false, error)
                return
            }
            
            guard let data = data else {
                showError("there is no data")
                return
            }
            
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
        
        
    }
    
    
    
    class func getStudentLocation(student: Bool, completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    class func postStudentLocation(student: Bool, completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
        
    }
    
    class func deletingSession(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
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
    
    class func postingStudentLocation(objectID: String, postLocation: PostLocation, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
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
    
    
    
}
