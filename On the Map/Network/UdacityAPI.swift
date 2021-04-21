//
//  UdacityAPI.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/25/21.
//

import Foundation
import UIKit



class UdacityAPI {
    
    
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        struct Auth {
            static var accountKey = "\(UserData.CodingKeys.key.rawValue)"
        }
        
        
        case login
        case getStudentLocation
        case postStudentLocation
        case getUserData
        case logout
        
        var urlString: String {
            switch self {
            
            case .login:
                return Endpoints.base + "/session"
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .getUserData:
                return Endpoints.base + "/users/" + "\(Auth.accountKey)"
            case .logout:
                return Endpoints.base + "session"
            }
            
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, removeFirstCharacters: Bool, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
           
           let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
               guard let data = data else {
                   DispatchQueue.main.async {
                       completion(nil, error)
                   }
                   return
               }
               var newData = data
               
            let range = 5..<data.count
               newData = newData.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            
               let decoder = JSONDecoder()
               do {
                   let responseObject = try decoder.decode(ResponseType.self, from: newData)
                   DispatchQueue.main.async {
                       completion(responseObject, nil)
                   }
               } catch {
                   DispatchQueue.main.async {
                       completion(nil, error)
                   }
               }
           }
           task.resume()
           
           return task
           
       }
       
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, removeFirstCharacters: Bool, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            var newData = data
            if removeFirstCharacters {
                let range = 5..<data.count
                newData = newData.subdata(in: range) /* subset response data! */
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PostLocationResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion((responseObject as! ResponseType), nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, ErrorMessage(message: error.localizedDescription ))
                    }
                }
            }
        }
        task.resume()
    }
           
           class func taskForDELETERequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (Bool, Error?) -> Void) -> URLSessionTask {
               taskForDELETERequest(url: Endpoints.logout.url, response: LogoutResponse.self) { (response, error) in
                   completion(response, error)
               }
              }
    
       
      class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> ()) {
           
        var request = URLRequest(url: Endpoints.login.url)
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
    
   
            
       
       class func getStudentLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
           
        let _ = taskForGETRequest(url: Endpoints.getStudentLocation.url, removeFirstCharacters: false, response: StudentLocationResults.self) { (response, error) in
                   if let response = response {
                       completion(response.results, nil)
                   } else {
                       completion([], ErrorMessage(message: "There was an error. Try again."))
                   }
               }
           
           
       }
       
    class func postStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, removeFirstCharacters: false, responseType: PostLocationResponse.self, body: PostLocationRequest(accountKey: Endpoints.Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)) { (_, error) in
                completion(error == nil, error)
            }
            
            
        }
       
       class func logout(completion: @escaping (Bool, Error?) -> Void) {
           let _ = taskForDELETERequest(url: Endpoints.logout.url, response: LogoutResponse.self) { (response, error) in
               completion(response, error)
           }
       }
       
       class func postingStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completion: @escaping (Bool, Error?) -> Void) {
           
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, removeFirstCharacters: false, responseType: PostLocationResponse.self, body: PostLocationRequest(accountKey: Endpoints.Auth.accountKey , firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)) { (_, error) in
               completion(error == nil, error)
           }
           
       }
       
    class func getPublicUserData(completion: @escaping (String?, String?, Error?) -> Void) {
        let _ = taskForGETRequest(url: Endpoints.getUserData.url, removeFirstCharacters: true, response: UserResponse.self) { (response, error) in
            if let response = response {
                completion(response.firstName, response.lastName, nil)
            } else {
                completion(nil, nil, error)
            }
        }
    }
    
}


