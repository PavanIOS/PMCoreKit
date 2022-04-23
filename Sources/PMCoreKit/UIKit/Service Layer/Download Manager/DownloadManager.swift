// Copyright 2017, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// Source    https://www.ralfebert.de/snippets/ios/urlsession-background-downloads/

import Foundation
import CoreGraphics


public class DownloadObject: NSObject {
    
    var completionBlock: DownloadManager.DownloadCompletionBlock?
    var progressBlock: DownloadManager.DownloadProgressBlock?
    
    var downloadStatusBlock:DownloadManager.DownloadStatusBlock?
    
    var downloadTask: URLSessionDownloadTask?
    var destinationPath = ""
    var fileName = ""
    var serverFilePath = ""
    
    var fileURL = ""
    var file: (size: Float, unit: String)?
    var downloadedFile: (size: Float, unit: String)?
    var remainingTime: (hours: Int, minutes: Int, seconds: Int)?
    var speed: (speed: Float, unit: String)?
    var progress: Float = 0
    var task: URLSessionDownloadTask?
    var startTime = Date()
    var completedStatus = false
    var allCompleted = false
    var error : Error?
    var downloadResponse : URLResponse!
    var errorMessage = ""
    var statusCode = -1
    
    override init() {
        
    }
    
    
}


public class DownloadManager : NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    static var shared = DownloadManager()
    
    public typealias DownloadCompletionBlock = (_ error : Error?, _ fileUrl:URL?,_ response:HTTPURLResponse) -> Void
    public typealias DownloadProgressBlock = (_ downloadModel : DownloadObject) -> Void
    public typealias BackgroundDownloadCompletionHandler = () -> Void
    
    
    public typealias DownloadStatusBlock = (_ downloadModel : DownloadObject) -> Void
    private var ongoingDownloads = [String:DownloadObject]()
    
    
    typealias ProgressHandler = (Float) -> ()
    typealias OnComplete = (Bool) -> ()
    
    
    
    var onProgress : ProgressHandler? {
        didSet {
            if onProgress != nil {
                let _ = activate()
            }
        }
    }
    
    var onComplete : OnComplete? {
        didSet {
            
        }
    }
    
    override private init() {
        super.init()
    }
    
    func downloadFile(urlStr:String,destinationPath:String,onProgress completionBlock:DownloadStatusBlock? = nil){
        
        if self.ongoingDownloads[urlStr] == nil {
            if  let url = urlStr.toUrl {
                let backgroundTask = self.activate().downloadTask(with: url)
                
                let downloadModel = DownloadObject()
                downloadModel.downloadTask = backgroundTask
                downloadModel.downloadStatusBlock = completionBlock
                downloadModel.fileURL = urlStr
                downloadModel.fileName = destinationPath.toFileUrl.fileNameWithoutExt
                downloadModel.destinationPath = destinationPath
                
                self.ongoingDownloads[urlStr] = downloadModel
                backgroundTask.resume()
            }
        }
    }
    
    
    func downloadFileWithRequest(urlStr:String,destinationPath:String,parameters: [String : Any]?,onProgress completionBlock:DownloadStatusBlock? = nil){
        
        var serverFilePath = ""
        if let docDetails = parameters?["DocumentDetails"] as? [String:Any] {
            if let filePath = docDetails["FilePath"] as? String {
                serverFilePath = filePath
            }
        }
        
        var alreadyAdded = false
        if let downloadObject = self.ongoingDownloads[urlStr] {
           if downloadObject.serverFilePath == serverFilePath {
                alreadyAdded = true
            }
        }
        if !alreadyAdded {
            if  let url = urlStr.toUrl {
                var request: URLRequest
                
                request = URLRequest(url: url)
                request.httpMethod = "POST"
                if let jsonData = try? JSONSerialization.data(withJSONObject: parameters as Any, options: .prettyPrinted) {
                    request.httpBody = jsonData
                    let length = "\(jsonData.count)"
                    request.addValue(length, forHTTPHeaderField: "Content-Length")
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let backgroundTask = self.activate().downloadTask(with: request)
                
                
                let downloadModel = DownloadObject()
                downloadModel.downloadTask = backgroundTask
                downloadModel.downloadStatusBlock = completionBlock
                downloadModel.fileURL = urlStr
                downloadModel.fileName = destinationPath.toFileUrl.fileNameWithoutExt
                downloadModel.destinationPath = destinationPath
                downloadModel.serverFilePath = serverFilePath
                
                self.ongoingDownloads[urlStr] = downloadModel
                backgroundTask.resume()
            }
        }
    }
    
    
    
    //    func downloadFile(urlStr: String,destinationFilePath:String,onProgress progressBlock:DownloadProgressBlock? = nil,
    //                      onCompletion completionBlock:@escaping DownloadCompletionBlock) {
    //
    //        if let url = urlStr.toUrl {
    //            let backgroundTask = self.activate().downloadTask(with: url)
    //
    //            let downloadModel = DownloadObject()
    //            downloadModel.downloadTask = backgroundTask
    //            downloadModel.progressBlock = progressBlock
    //            downloadModel.completionBlock = completionBlock
    //            downloadModel.fileURL = urlStr
    //            downloadModel.fileName = destinationFilePath.toFileUrl.fileNameWithoutExt
    //            downloadModel.destinationPath = destinationFilePath
    //
    //
    //            self.ongoingDownloads[urlStr] = downloadModel
    //            backgroundTask.resume()
    //        }
    //
    //    }
    
    
    
    func activate() -> URLSession {
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        
        // Warning: If an URLSession still exists from a previous download, it doesn't create a new URLSession object but returns the existing one with the old delegate object attached!
        return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }
    
    private func calculateProgress(session : URLSession, completionHandler : @escaping (Float) -> ()) {
        session.getTasksWithCompletionHandler { (tasks, uploads, downloads) in
            let progress = downloads.map({ (task) -> Float in
                if task.countOfBytesExpectedToReceive > 0 {
                    return Float(task.countOfBytesReceived) / Float(task.countOfBytesExpectedToReceive)
                } else {
                    return 0.0
                }
            })
            completionHandler(progress.reduce(0.0, +))
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesExpectedToWrite > 0 else {
            debugPrint("Could not calculate progress as totalBytesExpectedToWrite is less than 0")
            return
        }
        
        self.calculateProgress(session: session, completionHandler: { progressValue in
            if let key = (downloadTask.originalRequest?.url?.absoluteString) {
                if let downloadModel = self.ongoingDownloads[key],let downloadStatus = downloadModel.downloadStatusBlock  {
                    
                    let receivedBytesCount = Double(downloadTask.countOfBytesReceived)
                    let totalBytesCount = Double(downloadTask.countOfBytesExpectedToReceive)
                    let progress = Float(receivedBytesCount / totalBytesCount)
                    
                    let taskStartedDate = downloadModel.startTime
                    let timeInterval = taskStartedDate.timeIntervalSinceNow
                    let downloadTime = TimeInterval(-1 * timeInterval)
                    let speed = Float(totalBytesWritten) / Float(downloadTime)
                    let remainingContentLength = totalBytesExpectedToWrite - totalBytesWritten
                    let remainingTime = remainingContentLength / Int64(speed)
                    let hours = Int(remainingTime) / 3600
                    let minutes = (Int(remainingTime) - hours * 3600) / 60
                    let seconds = Int(remainingTime) - hours * 3600 - minutes * 60
                    
                    let totalFileSize = self.calculateFileSizeInUnit(totalBytesExpectedToWrite)
                    let totalFileSizeUnit = self.calculateUnit(totalBytesExpectedToWrite)
                    
                    let downloadedFileSize = self.calculateFileSizeInUnit(totalBytesWritten)
                    let downloadedSizeUnit = self.calculateUnit(totalBytesWritten)
                    
                    let speedSize = self.calculateFileSizeInUnit(Int64(speed))
                    let speedUnit = self.calculateUnit(Int64(speed))
                    
                    downloadModel.remainingTime = (hours, minutes, seconds)
                    downloadModel.file = (totalFileSize, totalFileSizeUnit as String)
                    downloadModel.downloadedFile = (downloadedFileSize, downloadedSizeUnit as String)
                    downloadModel.speed = (speedSize, speedUnit as String)
                    downloadModel.progress = progress
                    
                    OperationQueue.main.addOperation({
                        downloadStatus(downloadModel)
                    })
                }
            }
        })
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let key = (downloadTask.originalRequest?.url?.absoluteString) {
            if let downloadModel = self.ongoingDownloads[key],let downloadStatus = downloadModel.downloadStatusBlock  {
                removeKeyFromDownload(key: key)
                
                downloadModel.completedStatus = true
                if self.ongoingDownloads.count == 0 {
                    downloadModel.allCompleted = true
                }
                if let response = downloadTask.response {
                    _ = MediaUtilities.shared.moveFileToLocation(oldPath: location.path, newPath: downloadModel.destinationPath)
                    downloadModel.downloadResponse = response
                    OperationQueue.main.addOperation({
                        downloadStatus(downloadModel)
                    })
                }
                
            }
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error != nil {
            if let err = error as NSError? {
                if let urlKey = err.userInfo["NSErrorFailingURLStringKey"] as? String {
                    self.didCompleteWithError(urlKey, task, error)
                }
            }
        }else{
            if let key = (task.originalRequest?.url?.absoluteString) {
                self.didCompleteWithError(key, task, error)
            }
        }
        
    }
    
    func didCompleteWithError(_ key:String,_ task:URLSessionTask,_ error:Error?){
        if let downloadModel = self.ongoingDownloads[key],let downloadStatus = downloadModel.downloadStatusBlock  {
            removeKeyFromDownload(key: key)
            
            downloadModel.completedStatus = true
            downloadModel.error = error
            if self.ongoingDownloads.count == 0 {
                downloadModel.allCompleted = true
            }
            if let response = task.response {
                downloadModel.downloadResponse = response
            }
            
            OperationQueue.main.addOperation({
                downloadStatus(downloadModel)
            })
        }
    }
    
}

public extension DownloadManager {
    
    func removeKeyFromDownload(key:String?) {
        if let finalKey = key {
            if self.ongoingDownloads[finalKey] != nil && ongoingDownloads.count > 0 {
                self.ongoingDownloads.removeValue(forKey: finalKey)
            }
        }
    }
    
    func stopTask(fileUrl:String){
        if let downloadObject = self.ongoingDownloads[fileUrl],let downloadTask = downloadObject.downloadTask {
            downloadTask.suspend()
            removeKeyFromDownload(key: fileUrl)
            if self.ongoingDownloads.count == 0 {
                downloadObject.allCompleted = true
            }
        }
    }
    
    func resumeTask(fileUrl:String){
        if let downloadObject = self.ongoingDownloads[fileUrl],let downloadTask = downloadObject.downloadTask {
            downloadTask.resume()
        }
    }
    
    public func cancelAllDownloads() {
        for (_, download) in self.ongoingDownloads {
            if let downloadTask = download.downloadTask {
                downloadTask.cancel()
            }
        }
        self.ongoingDownloads.removeAll()
    }
    
    public func cancelDownload(forUniqueKey key:String?) {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        let presence = downloadStatus.0
        if presence {
            if let download = downloadStatus.1, let downloadTask = download.downloadTask{
                downloadTask.cancel()
                removeKeyFromDownload(key: key)
            }
        }
    }
    
    public func isDownloadInProgress(forKey key:String?) -> Bool {
        let downloadStatus = self.isDownloadInProgress(forUniqueKey: key)
        return downloadStatus.0
    }
    
    private func isDownloadInProgress(forUniqueKey key:String?) -> (Bool, DownloadObject?) {
        guard let key = key else { return (false, nil) }
        for (uniqueKey, download) in self.ongoingDownloads {
            if key == uniqueKey {
                return (true, download)
            }
        }
        return (false, nil)
    }
}

public extension DownloadManager {
    
    
    func calculateFileSizeInUnit(_ contentLength : Int64) -> Float {
        let dataLength : Float64 = Float64(contentLength)
        if dataLength >= (1024.0*1024.0*1024.0) {
            return Float(dataLength/(1024.0*1024.0*1024.0))
        } else if dataLength >= 1024.0*1024.0 {
            return Float(dataLength/(1024.0*1024.0))
        } else if dataLength >= 1024.0 {
            return Float(dataLength/1024.0)
        } else {
            return Float(dataLength)
        }
    }
    
    func calculateUnit(_ contentLength : Int64) -> NSString {
        if(contentLength >= (1024*1024*1024)) {
            return "GB"
        } else if contentLength >= (1024*1024) {
            return "MB"
        } else if contentLength >= 1024 {
            return "KB"
        } else {
            return "Bytes"
        }
    }
}
