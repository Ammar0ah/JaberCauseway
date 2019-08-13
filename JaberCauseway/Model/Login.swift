//
//  Login.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/10/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import UIKit

enum APIError : Error {
    case responseProblem
    case encodingProblem
    case decodingProblem
    
}


class Login : Codable {
    var UserName : String
    var UserPassword: String
    let WsPassword = "pen2019"
    let WsUsername = "pen2019"
    var device : Device = Device()
    init(user : String, pass: String ) {
        UserName = user
        UserPassword = pass
    }
    
    func post(Posturl:String , completion: @escaping ((Result<Response , APIError>) -> Void)){
        do{
            let url = URL(string: Posturl)!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(self)
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {
                data ,response , _ in
                guard let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 ,let jsonData = data else {
                    completion(.failure(.responseProblem))
                    
                    return
                }
  
                do {
                    let messageData = try JSONDecoder().decode(Response.self, from: jsonData)
                    
                    completion(.success(messageData))
                }catch {
                    let string = String(data:jsonData ,encoding: .utf8)
                    if string != nil{
                        if string!.contains("Invalid Password"){
                            let res = Response(desc:NSLocalizedString("Invalid Password", comment: ""))
                            completion(.success(res))
                        }else if string!.contains("User Not Registered"){
                            let res = Response(desc: NSLocalizedString("User Not Registered", comment: ""))
                            completion(.success(res))
                        }
                        else if string!.contains("Unfilled Fields"){
                            let res = Response(desc: NSLocalizedString("Unfilled Fields", comment: "") )
                            completion(.success(res))
                        }
                    }
                    else {
                        completion(.failure(.decodingProblem))
                    }
                    
                }
            }
            
            dataTask.resume()
        }
        catch {
            completion(.failure(.encodingProblem))
        }
    }
}

struct Device : Codable  {
    let Platform : String = "iOS"
    let Resolution = "\(screenSize)"
    let Version = systemVersion
    func serializeDevice() -> Dictionary<String , Any>{
        do {
            let jsonData = try JSONEncoder().encode(self)
         
            if let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String , Any> {
               return jsonObj
            }
            return ["" : ""]
        }
        catch{
            print("Couldn't Encode")
            return ["" : ""]
        }
       
    }
}
struct Response : Decodable {
    var ID : String
    var Description : String
    var ResultResponse : String
    init(desc : String) {
        Description = desc
        ID = ""
        ResultResponse = ""
    }
}

// Get Resolution
let screenBounds = UIScreen.main.bounds
let screenScale = UIScreen.main.scale
let screenSize = CGSize(width: screenBounds.width * screenScale, height: screenBounds.height * screenScale)
let systemVersion = UIDevice.current.systemVersion
