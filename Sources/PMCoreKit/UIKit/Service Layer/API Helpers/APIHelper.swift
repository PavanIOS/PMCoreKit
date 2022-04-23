//
//  ApiHelper.swift
//  GPServiceApi
//
//  Created by Rahul K. on 04/04/19.
//

import Foundation
import UIKit



public typealias APICompletionBlock = (_ response:Response) -> Void



public class APIHelper: NSObject {
    
    public static let shared = APIHelper()
    let syncQueue = DispatchQueue(label: "APIHelper")
    let group = DispatchGroup()
    
    var totalTasks = 0
    var completedTasks = 0
    
    
    public override init() {
        group.notify(queue: .main) {
           // print("all tasks done!")
            DispatchQueue.main.async {
                //  UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func commonService(parameters:[String: Any],endPoint:String,method: HTTPMethod = .POST, completion: @escaping APICompletionBlock) -> URLSessionDataTask {
        
        DispatchQueue.main.async {
            //  UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        group.enter()
        self.totalTasks =  self.totalTasks + 1
        let finalUrl = NetworkUrls.Base_Url + endPoint
        let sessionData = APIClient.shared.request(urlpath: finalUrl, method: method, parameters: parameters) {
            (data, error,response) in
            
            self.completedTasks =  self.completedTasks + 1
            
            let resp = self.getResponse(response: response, error: error)
            if data != nil && resp.isSuccess{
                resp.collectData.append(data!)
            }
            completion(resp)
            
            self.syncQueue.async {
                self.group.leave()
            }
        }
        return sessionData
    }
    
    func sendimageToServer(endPoint:String,parameters:[String : String],fileName:String,ContentType: String,filePath:URL,completion: @escaping APICompletionBlock) -> URLSessionDataTask {
        
        group.enter()
        
        return UploadManager.shared.imageUpload(endPoint: endPoint, parameters: parameters, fileName: fileName, fileType: ContentType, filePath: filePath, completion: { (data, error,response)  in
            self.completedTasks =  self.completedTasks + 1
            
            let resp = self.getResponse(response: response, error: error)
            if data != nil && resp.isSuccess{
                resp.collectData.append(data!)
            }
            completion(resp)
            
            self.syncQueue.async {
                self.group.leave()
            }
        })
        
        
    }
    
    
    
    func directCommonService(parameters:[String: Any],endPoint:String,method: HTTPMethod = .POST, completion: @escaping APICompletionBlock) -> URLSessionDataTask {
        
        DispatchQueue.main.async {
            //  UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        group.enter()
        self.totalTasks =  self.totalTasks + 1
        let finalUrl = endPoint
        let sessionData = APIClient.shared.request(urlpath: finalUrl, method: method, parameters: parameters) {
            (data, error,response) in
            
            self.completedTasks =  self.completedTasks + 1
            
            let resp = self.getResponse(response: response, error: error)
            if data != nil && resp.isSuccess{
                resp.collectData.append(data!)
            }
            completion(resp)
            
            self.syncQueue.async {
                self.group.leave()
            }
        }
        return sessionData
    }
    
}

extension APIHelper {
    func getResponse(response:HTTPURLResponse,error:Error?) -> Response{
        let resp = Response()
        resp.headers = response.allHeaderFields as? Dictionary<String,String>
        resp.mimeType = response.mimeType
        resp.suggestedFilename = response.suggestedFilename
        resp.statusCode = response.statusCode
        resp.URL = response.url
        
        if let code = resp.statusCode, code > 299 {
            resp.error = self.createError(code)
        }
        if error != nil {
            resp.error = error
        }
        return resp
    }
    
    func replaceExtraCharFromResponse(responseText:String) -> String {
        var responseData = responseText
        if responseData.starts(with: "\"") {
            responseData.removeFirst()
        }
        if responseData.last == "\"" {
            responseData.removeLast()
        }
        
        responseData = responseData.replace("\\\"", "\"")
        responseData = responseData.replace("\\\\", "\\")
        return responseData
    }
    
    fileprivate func createError(_ code: Int) -> NSError {
        let text = HTTPStatusCode(statusCode: code).statusDescription
        return NSError(domain: "HTTP", code: code, userInfo: [NSLocalizedDescriptionKey: text])
    }
    
}


//extension APIHelper {
//    
//    func getAppVersion() -> String {
//              let version = Bundle.main.version
//              let build = Bundle.main.build
//              // let version = "2.0.2(Beta_ui)"
//              let urlHint = NetworkUrls.URL_HINT
//              return "V_\(version)(\(build))(\(urlHint))"
//          }
//    
//     func getSecurityValues(_ userName:String,_ password:String)->[String: String] {
//        let loginDictionary:[String: String] = ["LoginID":userName,"Password":password,"DeviceId":Device.uuidString,"ClientBuildVersion":self.getAppVersion(),"Platform":"IOS"]
//        return loginDictionary
//    }
//    
//    func getSecurityLoginValues(_ loginId:String,_ password:String)->[String: String] {
//        let loginDictionary:[String: String] = ["LoginID":loginId,"Password":password,"DeviceId":Device.uuidString,"ClientBuildVersion":self.getAppVersion(),"Platform":"IOS"]
//        return loginDictionary
//    }
//    
//    func getMainEntityJsonObject(_ userName:String,_ password:String,_ mainJson:JSON) -> [String:Any]? {
//        
//        let securityObject = self.getSecurityValues(userName, password)
//        let mainJson = JSON.init(dictionaryLiteral: ("SecurityEntity",securityObject),("MainEntity",mainJson)).dictionaryObject
//        return mainJson
//    }
//    
//    func getMainEntityLoginJsonObject(_ loginId:String,_ password:String,_ mainJson:JSON) -> [String:Any]? {
//        
//        let securityObject = self.getSecurityLoginValues(loginId, password)
//        let mainJson = JSON.init(dictionaryLiteral: ("SecurityEntity",securityObject),("MainEntity",mainJson)).dictionaryObject
//        return mainJson
//    }
//    
//    func getSingleMainEntityJsonObject(_ mainJson:JSON) -> [String:Any]? {
//        let mainJson = JSON.init(dictionaryLiteral: ("MainEntity",mainJson)).dictionaryObject
//        return mainJson
//    }
//    
//    func getSecurityEntityJsonObject(_ userName:String,_ password:String) -> [String:Any]? {
//        let securityObject = self.getSecurityValues(userName, password)
//        let mainJson = JSON.init(dictionaryLiteral: ("SecurityEntity",securityObject)).dictionaryObject
//        return mainJson
//    }
//    
//    func appendMainJsonObject(mainJson:JSON) -> [String:Any]?{
//        if let securityObj = APIHelper.shared.getSecurityEntityJsonObject("", "") {
//            let mainJsonDict = JSON.init(dictionaryLiteral: ("SecurityEntity",securityObj),("MainEntity",mainJson)).dictionaryObject
//            return mainJsonDict
//        }
//        return nil
//    }
//    
//    func getAuthenticationJsonObject(_ userName:String,_ password:String,_ fireBaseId:String)-> [String:Any]?{
//            let securityObject = self.getSecurityValues(userName, password)
//           let mainObject:[String: String] = ["FirebaseDeviceId": fireBaseId]
//           let mainJson = JSON.init(dictionaryLiteral: ("SecurityEntity",securityObject),("MainEntity",mainObject)).dictionaryObject
//           return mainJson
//       }
//    
//}


extension APIHelper {
    func postCommonService(parameters:String,endPoint:String,method: HTTPMethod = .POST, completion: @escaping APICompletionBlock) -> URLSessionDataTask {
        
        DispatchQueue.main.async {
            //  UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        group.enter()
        self.totalTasks =  self.totalTasks + 1
        let finalUrl = NetworkUrls.Base_Url + endPoint
        let sessionData = APIClient.shared.postRequest(urlpath: finalUrl, method: method, parameters: parameters) {
            (data, error,response) in
            
            self.completedTasks =  self.completedTasks + 1
            
            let resp = self.getResponse(response: response, error: error)
            if data != nil && resp.isSuccess{
                resp.collectData.append(data!)
            }
            completion(resp)
            
            self.syncQueue.async {
                self.group.leave()
            }
        }
        return sessionData
    }
}
