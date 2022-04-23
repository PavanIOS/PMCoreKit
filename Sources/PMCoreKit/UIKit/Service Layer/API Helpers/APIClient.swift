//
//  CommonService.swift
//  GPServiceApi
//
//  Created by Rahul K. on 03/04/19.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

public class APIClient{
    
    static let shared = APIClient()
    
    var authorizationToken = ""
    
    var session: URLSession
    
    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
        
        self.session = URLSession(configuration: configuration,
                                  delegate: nil,
                                  delegateQueue: OperationQueue.main)
    }
    public func request(urlpath: String,
                        method: HTTPMethod = .GET,
                        parameters: [String : Any]?,
                        completion: ((_ data:Data?,_ error:Error?,_ response:HTTPURLResponse) -> ())?) -> URLSessionDataTask {
        var request: URLRequest
        
        if method == .POST {
            let urlString = urlpath
            
            request = URLRequest(url: URL(string: urlString as String)! )
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters as Any, options: .prettyPrinted) {
                request.httpBody = jsonData
                let length = "\(jsonData.count)"
                request.addValue(length, forHTTPHeaderField: "Content-Length")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        else {
            let urlString:String?
            if parameters != nil {
                urlString  = urlpath + "?" + buildQueryString(fromDictionary: parameters! as! [String : String])
            }else{
                urlString = urlpath as String
            }
            request = URLRequest(url: URL(string: urlString! )! )
        }
        
//        if !urlpath.contains(ServiceConstants.REFRESH_TOKEN) {
//             let tokenDataModel = TokenDataStore().getData()
//                self.authorizationToken = tokenDataModel.getToken()
//            request.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
//        }
        
        request.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request ) {
            (data, response, error) -> Void in
            
            if response == nil {
                completion?(data, error,HTTPURLResponse.init())
            }
            else{
                completion?(data, error,response as! HTTPURLResponse)
            }
        }
        task.resume()
        return task
    }
    
    private func buildQueryString(fromDictionary parameters: [String: String]) -> String {
        var urlVars = [String]()
        for (key, var val) in parameters {
            val = val.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            urlVars += [key + "=" + "\(val)"]
        }
        return urlVars.joined(separator: "&")
    }
    
    
}



extension APIClient {
    public func postRequest(urlpath: String,
                            method: HTTPMethod = .POST,
                            parameters: String,
                            completion: ((_ data:Data?,_ error:Error?,_ response:HTTPURLResponse) -> ())?) -> URLSessionDataTask {
        var request: URLRequest
        
        let urlString = urlpath
        
        request = URLRequest(url: URL(string: urlString as String)!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 50)
         
        
        if let postData = parameters.data(using: .utf8) {
            request.httpBody = postData
            let length = "\(postData.count)"
            request.addValue(length, forHTTPHeaderField: "Content-Length")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request ) {
            (data, response, error) -> Void in
            
            if response == nil {
                completion?(data, error,HTTPURLResponse.init())
            }
            else{
                completion?(data, error,response as! HTTPURLResponse)
            }
        }
        task.resume()
        return task
    }
}



