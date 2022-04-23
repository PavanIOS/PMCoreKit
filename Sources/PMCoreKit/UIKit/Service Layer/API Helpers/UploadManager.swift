//
//  APIMediaClient.swift
//  ShiftBoss
//
//  Created by Pavan on 06/05/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import Foundation
import MobileCoreServices



@objc protocol APIMediaClientDelegate {
    @objc optional func uploadStarted()
    @objc optional func uploadUpdated(_ progress : NSNumber)
    @objc optional func uploadEnded()
    @objc optional func showError(_ message: String, title: String?)
    @objc optional func uploadFailed()
}

public typealias UploadManagerCompletionBlock = (_ data: Data?, _ error: Error?,_ response:HTTPURLResponse) -> Void

public class UploadManager {
    var session: URLSession
    static let shared = UploadManager()
    
    public init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : "multipart/form-data; boundary=\(DateFormats.getCurrentMillis())",
            "Content-Type" : "multipart/form-data; boundary=\(DateFormats.getCurrentMillis())"]
        self.session = URLSession(configuration: configuration,
                                  delegate: nil,
                                  delegateQueue: OperationQueue.main)
    }
    
    fileprivate func createError(_ code: Int) -> NSError {
        let text = HTTPStatusCode(statusCode: code).statusDescription
        return NSError(domain: "HTTP", code: code, userInfo: [NSLocalizedDescriptionKey: text])
    }
    
    fileprivate func upload(endPoint:String,parameters:[String:String]?,fileName:String,fileType:String,filePath:URL,completion: @escaping UploadManagerCompletionBlock) -> URLSessionDataTask {
    
        let urlString =  NetworkUrls.Image_Base_Url + endPoint
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
         let mimetype = self.mimeType(forPath: filePath.path)
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let test = String((value ).filter { !"\n\t\r".contains($0) })
                request.setValue(test, forHTTPHeaderField: key)
            }
            if parameters["content_type"] == nil {
                 request.setValue(mimetype, forHTTPHeaderField: "content_type")
            }
        }
       
        let imageData = MediaUtilities.shared.toData(localUrl: filePath)
                
        let body = NSMutableData()
        let fname = fileName
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition:form-data; name=\"doc\"\r\n\r\n")
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string:"Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n")
        body.appendString(string:"Content-Type: \(mimetype)\r\n\r\n")
        if let imageData = imageData {
           body.append(imageData)
        }
        body.appendString(string:"\r\n")
        body.appendString(string:"--\(boundary)--\r\n")
        request.httpBody = body as Data
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            if response == nil {
                completion(data, error,HTTPURLResponse.init())
            }else{
                completion(data, error,response as! HTTPURLResponse)
            }
        }
        task.resume()
        
        return task
    }
    
    func imageUpload(endPoint:String,parameters:[String:String]?,fileName:String,fileType:String,filePath:URL,completion: @escaping UploadManagerCompletionBlock) -> URLSessionDataTask{
        
        return self.upload(endPoint: endPoint, parameters: parameters, fileName: fileName, fileType: fileType, filePath: filePath, completion: { (data, error, response) in
            completion(data, error ,response)
        })
    }
    
    func videoUpload(endPoint:String,parameters:[String:String]?,fileName:String,fileType:String,filePath:URL,completion: @escaping UploadManagerCompletionBlock) -> URLSessionDataTask{
        return self.upload(endPoint: endPoint, parameters: parameters, fileName: fileName, fileType: fileType, filePath: filePath, completion: { (data, error, response) in
            
            completion(data, error ,response)
        })
    }
    
    func fileUpload(endPoint:String,parameters:[String:String]?,fileName:String,fileType:String,filePath:URL,completion: @escaping UploadManagerCompletionBlock) -> URLSessionDataTask{
        return self.upload(endPoint: endPoint, parameters: parameters, fileName: fileName, fileType: fileType, filePath: filePath, completion: { (data, error, response) in
            completion(data, error ,response)
        })
    }
    
    
    
    
    
    
}

//extension APIMediaClient {
//    public func uploadImage(path: String,
//                            parameters: [String : String]?,
//                            fileName: String,
//                            fileType: String,
//                            filePath : URL,
//                            completion: @escaping MediaClientCompletionBlock) -> URLSessionDataTask {
//
//
//
//
//        let urlString =  NetworkUrls.baseUrl + path
//
//
//
//
//        let url = URL(string: urlString)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let boundary = generateBoundaryString()
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        for (key, value) in parameters! {
//            let test = String((value ).filter { !"\n\t\r".contains($0) })
//            request.setValue(test, forHTTPHeaderField: key)
//        }
//        let imageData = self.convertFileUrlToData(localUrl: filePath)
//
//
//
//        let body = NSMutableData()
//        let fname = fileName
//        let mimetype = fileType
//        body.appendString(string: "--\(boundary)\r\n")
//        body.appendString(string: "Content-Disposition:form-data; name=\"test\"\r\n\r\n")
//        body.appendString(string: "\r\n")
//        body.appendString(string: "--\(boundary)\r\n")
//        body.appendString(string:"Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n")
//        body.appendString(string:"Content-Type: \(mimetype)\r\n\r\n")
//        body.append(imageData!)
//        body.appendString(string:"\r\n")
//        body.appendString(string:"--\(boundary)--\r\n")
//        request.httpBody = body as Data
//
//
//        let task = URLSession.shared.dataTask(with: request) {
//            (data, response, error) -> Void in
//            if (data == nil || error != nil) {
//                if response == nil {
//                    completion(nil, error ,HTTPURLResponse.init())
//                }else{
//                    completion(nil, error ,response as! HTTPURLResponse)
//                }
//            } else {
//                completion(data , error ,response as! HTTPURLResponse)
//            }
//        }
//        task.resume()
//
//        return task
//    }
//
//
//
//    func convertFileUrlToData(localUrl : URL) -> Data?{
//        if MediaUtilities.exists(fileURL: localUrl) {
//            do {
//                let imageData = try Data(contentsOf: localUrl)
//                return imageData
//            } catch {
//                print("Unable to load data: \(error)")
//            }
//        }
//        return nil
//    }
//}

public extension UploadManager {
    
    func generateBoundaryString() -> String {
        return "===\(DateFormats.getCurrentMillis())==="
    }
    
    func mimeType(forPath path: String) -> String {
        // get a mime type for an extension using MobileCoreServices.framework
        let url = path.toFileUrl
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

