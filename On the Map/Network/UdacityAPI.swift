//
//  UdacityAPI.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/25/21.
//


import Foundation
import UIKit
import MapKit



class UdacityAPI {
    
    static var shared = UdacityAPI()
        var firstName = ""
        var lastName = ""
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        struct Auth {
            static var accountKey = ""
            
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
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let responseObject = try decoder.decode(PostLocationResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion((responseObject as! ResponseType), nil)
                }
            } catch {
                completion(nil, ErrorMessage(message: error.localizedDescription ))
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
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print(error?.localizedDescription ?? "")
                return
            }
            
            guard let data = data else {
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(LoginResponse.self, from: newData)
                let accountId = decoded.account.key
                
                self.Endpoints.Auth.accountKey = accountId!
                print("Account Key is \(String(describing: accountId))")
                completion(true, nil)
                
            } catch let error {
                print(error.localizedDescription)
                completion(false, nil)
            }
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
            taskForPOSTRequest(url: Endpoints.postStudentLocation.url, removeFirstCharacters: false, responseType: PostLocationResponse.self, body: PostLocationRequest(uniqueKey: Endpoints.Auth.accountKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)) { (_, error) in
                completion(error == nil, error)
            }
        }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        let _ = taskForDELETERequest(url: Endpoints.logout.url, response: LogoutResponse.self) { (response, error) in
            completion(response, error)
        }
    }
    
    
    
    class func getPublicUserData(completion: @escaping (String?, String?, Error?) -> Void) {
        let _ = taskForGETRequest(url: Endpoints.getUserData.url, removeFirstCharacters: false, response: UserData.self) { (response, error) in
            if let response = response {
//                UdacityAPI.shared.firstName = response.firstName
//                UdacityAPI.shared.lastName = response.lastName
                completion(response.firstName, response.lastName, nil)
                
                
                
            } else {
                completion(nil, nil, error)
            }
        }
    }
    
    
    
}
