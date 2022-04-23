//
//  HttpDownloader.swift
//  ShiftBoss
//
//  Created by Pavan on 25/04/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import Foundation

class HttpDownloader{
    
    static let shared = HttpDownloader()
    
    func downloadFile(urlStr: String,destinationFilePath:String,completion:@escaping (_ path:String, _ comment:String, _ statusCode:Int) -> Void) {
        if let url = URL(string: urlStr) {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url: url)
            let destinationFilePath:URL = URL(fileURLWithPath: destinationFilePath)
            
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    if ((response as? HTTPURLResponse)?.statusCode) != nil {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode
                        if   statusCode == 200 {
                            
                            _ = MediaUtilities.shared.moveFileToLocation(oldPath: tempLocalUrl.path, newPath: destinationFilePath.path)
                            completion(destinationFilePath.path, "success", 0)
                            return
                        }
                        completion(tempLocalUrl.path, error.debugDescription, statusCode!)
                        return
                    }
                } else{
                    completion("", error.debugDescription, -1)
                }
            }
            task.resume()
        }else{
            completion("", "Url not found", -1)
        }
    }
    
}



