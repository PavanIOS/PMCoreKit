//
//  MediaUtilities.swift
//  ShiftBoss
//
//  Created by sn99 on 23/05/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import Foundation
import UIKit



// Reference Link - https://iswift.org/cookbook/write-data-to-file

/*
 // Basic Usage
 /// - Updated Usage
 let directory = MediaUtilities.shared.createAndMoveToImagesFolder(fileUrl,fileUrl.lastPathComponent)
 
 
 let newImagePath = MediaUtilities.createNewCameraRollImageFileName()
 var cameraDirectory = MediaUtilities.getCameraDirectory()
 cameraDirectory.appendPathComponent(newImagePath)
 MediaUtilities.saveImageToDirectory(ImageNames.DoctorImage, cameraDirectory)
 
 */

public class FolderNames {
    static let Temp = "Temp"
    static let DOCUMENTS = "Documents"
    static let MESSAGING = "Messages"
    static let IMAGES = "Images"
}



public class MediaUtilities {
    
    static let shared = MediaUtilities()
    
    
    
    func getRootDirectory() -> URL? {
        let fileManager = FileManager.default
        var documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first
        documentDirectory?.appendPathComponent(Bundle.main.displayName + "/")
        return documentDirectory
    }
    
    func getFolderPath(folderName:String) -> URL? {
        if let documentDirectory = self.getRootDirectory() {
            let root = folderName.removeWhitespace()
            let folderURL = documentDirectory.appendingPathComponent(root)
            return folderURL
        }
        return nil
    }
    
    func deleteFilePath(filePath:String) -> Bool{
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
                return true
            }
            catch let error {
                print("Error: \(error.localizedDescription)")
                return false
            }
        }
        
        return false
    }
    
    func deleteFolder(folderName:String) -> Bool{
        let fileManager = FileManager.default
        if let folderPath = self.getFolderPath(folderName: folderName) {
            if fileManager.fileExists(atPath: folderPath.path) {
                do {
                    try fileManager.removeItem(atPath: folderPath.path)
                    return true
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                    return false
                }
            }
        }
        return false
    }
    
    func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = self.getRootDirectory() {
            let folderURL = documentDirectory.appendingPathComponent(folderName.removeWhitespace())
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
            return folderURL
        }
        return nil
    }
    
    func exists (fileURL: URL) -> Bool {
        return FileManager().fileExists(atPath: fileURL.path)
    }
    
    func fileSize(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            if(exists (fileURL: url!)){
                let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
                if let size = attribute[FileAttributeKey.size] as? NSNumber {
                    return size.doubleValue
                }
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    func covertToFileString(with size: Double) -> String {
        var convertedValue = size
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.1f %@", convertedValue, tokens[multiplyFactor])
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func getFileSizeString(fielUrl:URL) -> String{
        let fileSize1 = self.fileSize(url: fielUrl)
        let formattedString = self.covertToFileString(with: fileSize1)
        return formattedString
    }
}


public extension MediaUtilities {
    
    func saveImageToDirectory(_ image:UIImage,_ fileURL:URL) {
        do {
            if let imageData = image.jpeg(.high) {
                try imageData.write(to: fileURL)
            }
        } catch {
            print(error)
        }
    }
    
    func getFilesFromFolder(folderName:String) -> [URL]{
        let fileManager = FileManager.default
        var theItems = [URL]()
        if let documentDirectory = self.getRootDirectory()
        {
            let root = folderName.removeWhitespace()
            let folderURL = documentDirectory.appendingPathComponent(root)
            
            do {
                theItems = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])
                print(theItems)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return theItems
    }
    
    func moveFileToLocation(oldPath:String,newPath:String) -> Bool{
        
        if FileManager.default.fileExists(atPath: oldPath) {
           
            let fileManager = FileManager.default
            do {
                try fileManager.moveItem(atPath: oldPath, toPath: newPath)
                _ = self.deleteFilePath(filePath: oldPath)
                return true
            }
            catch {
                print("\(error.localizedDescription)")
            }
            return false
        }
        return false
    }
    
    func copyFileToLocation(oldPath:String,newPath:String) -> Bool{
        
        let fileManager = FileManager.default
        do {
            try fileManager.copyItem(atPath: oldPath, toPath: newPath)
            _ = self.deleteFilePath(filePath: oldPath)
            return true
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        return false
    }
    
    func getAttributesOfFilePath(filePath:String) {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfItem(atPath: filePath)
            print(attributes)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func toData(localUrl:URL) -> Data? {
        if self.exists(fileURL: localUrl) {
            do {
                let imageData = try Data(contentsOf: localUrl)
                return imageData
            } catch {
                print("Unable to load data: \(error)")
            }
        }
        return nil
    }
}

public extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}

// MARK: FileManager public extension
public extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL] {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs ?? [URL]()
    }
}







//MARK: - Media Directories
public extension MediaUtilities {
    
    func getTempDirectory() -> URL{
        return self.createFolder(folderName: FolderNames.Temp)!
    }
    
    func getDocumentsDirectory() -> URL {
        return self.createFolder(folderName: FolderNames.DOCUMENTS)!
    }
    
    func getMessagingDirectory() -> URL {
        return self.createFolder(folderName: FolderNames.MESSAGING)!
    }
    
    func getImagesDirectory() -> URL {
        return self.createFolder(folderName: FolderNames.IMAGES)!
    }
    
    
    private func getCurrentTimeForFiles() -> String{
        let createdTime = Date()
        var fileName = getCurretDateTime()
        fileName = fileName+DateFormats.convertToTimestamp(date: createdTime)
        return fileName
    }
    
     func getCurretDateTime() -> String{
        let createdTime = Date()
        let dateTime = createdTime.toString("YYYYMMddHHmmss")
        return dateTime
    }
    
        private func getOriginalFileNameTimeStamp(_ fileName:String) -> String {
            let pathExtension = fileName.pathExtension
            let timeStamp = getCurrentTimeForFiles()
            return fileName.deletingPathExtension + "_" + timeStamp + ".\(pathExtension)"
        }
    
    
    //    private func getImagesFileName(_ oldFileName:String = "") -> String {
    //        var fileName = getCurrentTimeForFiles()
    //        if oldFileName == "" {
    //            fileName = "Images_\(fileName).png"
    //        }else{
    //            fileName = "Images_\(oldFileName)"
    //        }
    //        return fileName
    //    }
    
    
    //    func createTempName(_ oldFileName:String = "") -> String {
    //        var fileName = ""
    //        if oldFileName == "" {
    //            fileName = "Temp.png"
    //        }else{
    //            fileName = "Temp\(fileName).\(oldFileName.pathExtension)"
    //        }
    //        return fileName
    //    }
    
    
    //    func createCameraName(_ oldFileName:String = "") -> String {
    //        var fileName = ""
    //        if oldFileName == "" {
    //            fileName = "Camera.png"
    //        }else{
    //            fileName = "Camera\(fileName).\(oldFileName.pathExtension)"
    //        }
    //        return fileName
    //    }
    //
    
    
    
    
    
    //    func getImagesDirectory(_ oldFileName:String = "") -> URL {
    //        let fileEndPoint = createNewImageFileName(oldFileName)
    //        return getImagesDirectory().appendingPathComponent(fileEndPoint)
    //    }
    
    
}




//MARK: - Final Methods
public extension MediaUtilities {
    
    
    func getAttachmentHandlerImageFilePath(_ oldFileName:String = "") -> URL{
        
        if oldFileName == "" {
            return getImagesFileUrl(oldFileName)
        }
        else{
            return getImagesDirectory().appendingPathComponent(oldFileName)
        }
    }
    
    func getImagesFileUrl(_ oldFileName:String = "") -> URL {
        let fileEndPoint = createNewImageFileName(oldFileName)
        return getImagesDirectory().appendingPathComponent(fileEndPoint)
    }
    
    func createNewImageFileName(_ oldFileName:String = "") -> String {
        let createdTime = Date()
        var fileName = createdTime.toString("YYYYMMddHHmmss_")
        fileName = fileName+DateFormats.convertToTimestamp(date: createdTime)
        
        if oldFileName == "" {
            fileName = "IMAGES_\(fileName).png"
        }
        else if oldFileName.contains("IMAGES_"){
            fileName = oldFileName
        }
        else{
            fileName = "IMAGES_\(oldFileName)"
        }
        return fileName
    }
    
    
    private func getMessagingFileUrl(_ oldFileName:String = "") -> URL {
        let fileName = createNewMessagingFileName(oldFileName)
        return getMessagingDirectory().appendingPathComponent(fileName)
    }
    
    func createNewMessagingFileName(_ oldFileName:String) -> String {
        var fileName = getOriginalFileNameTimeStamp(oldFileName)
        
        fileName = fileName.replace("IMAGES_", "")
        
        if oldFileName.contains("Message_") {
            fileName = oldFileName
        }
        else if oldFileName.contains("Temp"){
            fileName = "Message_\(fileName)"
        }
        else{
            fileName = "Message_\(fileName)"
        }
        fileName = fileName.replace("_Camera", "")
        return fileName
    }

    
    private func getDocumentFileUrl(_ oldFileName:String = "") -> URL {
        let fileName = createNewDocumentFileName(oldFileName)
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    func createNewDocumentFileName(_ oldFileName:String) -> String {
        var fileName = getOriginalFileNameTimeStamp(oldFileName)
        
        if fileName.contains("Doc_") {
            fileName = oldFileName
        }else if fileName.contains("Temp"){
            fileName = fileName.replace("Temp", "Doc")
        }else{
            fileName = "Doc_\(fileName)"
        }
        fileName = fileName.replace("_Camera", "")
        return fileName
    }
    
    
    func createAndMoveToImagesFolder(_ oldPath:URL,_ oldFileName:String = "") -> URL {
        
        let newFilePath = getImagesFileUrl(oldFileName)
        
        _ = self.moveFileToLocation(oldPath: oldPath.path, newPath: newFilePath.path)
        return newFilePath
    }
    
    func createAndMoveToMessagingFolder(_ oldPath:URL,_ oldFileName:String = "") -> URL {
        
        let newFilePath = getMessagingFileUrl(oldFileName)
        _ = self.moveFileToLocation(oldPath: oldPath.path, newPath: newFilePath.path)
        return newFilePath
    }
    
    func createAndMoveToDocumentsFolder(_ oldPath:URL,_ oldFileName:String = "") -> URL {
        let newFilePath = getDocumentFileUrl(oldFileName)
        
        _ = self.moveFileToLocation(oldPath: oldPath.path, newPath: newFilePath.path)
        return newFilePath
    }
    
    
    func createAndSaveToImagesFolder(oldFileName:String = "") -> URL {
        let newFilePath = getAttachmentHandlerImageFilePath(oldFileName)
        
        _ = self.moveFileToLocation(oldPath: oldPath.path, newPath: newFilePath.path)
        return newFilePath
    }
    
}
