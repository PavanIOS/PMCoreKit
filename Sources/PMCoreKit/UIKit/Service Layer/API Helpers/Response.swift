//
//  Response.swift
//  GPLibraryExample
//
//  Created by sn99 on 27/09/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import Foundation


/**
All the things of an HTTP response
*/


 public class Response {
    open var headers: Dictionary<String,String>?
    open var mimeType: String?
    open var suggestedFilename: String?
    open var data: Data {
        return collectData as Data
    }
    open var statusCode: Int?
    
    var isSuccess : Bool {
        get {
            return self.statusCode == 200 && error == nil
        }
    }
    
    open var URL: Foundation.URL?
    open var error: Error?
    open var text: String {
        return  String(data: data, encoding: .utf8) ?? ""
    }
    open var description: String {
        var buffer = ""
        if let u = URL {
            buffer += "URL:\n\(u)\n\n"
        }
        if let code = self.statusCode {
            buffer += "Status Code:\n\(code)\n\n"
        }
        if let heads = headers {
            buffer += "Headers:\n"
            for (key, value) in heads {
                buffer += "\(key): \(value)\n"
            }
            buffer += "\n"
        }
        if  text != "" {
            buffer += "Payload:\n\(text)\n"
        }
        return buffer
    }
    
    var collectData = NSMutableData()
    
    var responseData = ""
    open var jsonData: [String:Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
        }
        return nil
    }
    
}
