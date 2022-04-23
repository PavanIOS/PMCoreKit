//
//  image.swift
//  GPServiceApi
//
//  Created by Rahul K. on 04/04/19.
//  Copyright © 2019 Gpinfotech. All rights reserved.
//



import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

/*
 AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
 AttachmentHandler.shared.imagePickedBlock = { (image) in
 /* get your image here */
 }
 */



public class AttachmentHandler: NSObject{
    
    
    
    
    static let shared = AttachmentHandler()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage,URL?) -> Void)?
    var videoPickedBlock: ((URL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    
    let imageEditorApiKey = "398f6109966ea7a5b510bf2fa6221d959970712b"
    
    public enum AttachmentType: String{
        case camera, video, photoLibrary, file
    }
    
    
    
    
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let photoLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        
        
        static let enableCamera = "Enable Camera"
        static let enablePhotoLibrary = "Enable Photo Library"
        static let enableVideo = "Enable Video Permission"
        
        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
        
    }
    
    
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    public func showAttachmentActionSheet(vc: UIViewController,types:[AttachmentType]) {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        if types.contains(.camera) {
            actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
                self.authorisationCameraStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
            }))
        }
        
        if types.contains(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: Constants.photoLibrary, style: .default, handler: { (action) -> Void in
                self.authorisationLibraryStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
            }))
        }
        if types.contains(.video) {
            actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
                self.authorisationLibraryStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
            }))
        }
        
        if types.contains(.file) {
            actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
                self.documentPicker()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = vc.view
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
        }
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Authorisation Status
    
    func authorisationLibraryStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        currentVC = vc
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
            break
        case .denied:
            print("permission denied")
            self.addAlertForSettings(attachmentTypeEnum)
            break
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        DispatchQueue.main.async {
                            self.openCamera()
                        }
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        DispatchQueue.main.async {
                            self.photoLibrary()
                        }
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        DispatchQueue.main.async {
                            self.videoLibrary()
                        }
                    }
                }
            })
            
        default:
            break
        }
    }
    
    
     func authorisationCameraStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController) {
       
            self.currentVC = vc
        
        let cameraMediaType = AVMediaType.video
        let status = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
            break
        case .denied:
            print("permission denied")
            self.addAlertForSettings(attachmentTypeEnum)
            break
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(attachmentTypeEnum)
            break
        case .notDetermined:
            print("Permission Not Determined")
            
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        if attachmentTypeEnum == AttachmentType.camera{
                            DispatchQueue.main.async {
                                self.openCamera()
                            }
                        }
                        if attachmentTypeEnum == AttachmentType.photoLibrary{
                            DispatchQueue.main.async {
                                self.photoLibrary()
                            }
                        }
                        if attachmentTypeEnum == AttachmentType.video{
                            DispatchQueue.main.async {
                                self.videoLibrary()
                            }
                        }
                    } else {
                        // do something else
                    }
                }
            }
            
        default:
            break
        }
        
    }
    
    func checkPhotoLibraryPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            // ask for permissions
            return true
        case .denied, .restricted:
            return false
        case .limited:
            return true
        @unknown default:
            return false
        }
    }
    
    
    //MARK: - CAMERA PICKER
    public func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }else{
            DispatchQueue.main.async {
                CommonAlertView.shared.showAlert("Camera not available")
            }
        }
    }
    
    
    //MARK: - PHOTO PICKER
    public func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            //  myPickerController.allowsEditing = false
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - VIDEO PICKER
    public func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - FILE PICKER
    public func documentPicker(){
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeRTFD),String(kUTTypeFlatRTFD),"public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        currentVC?.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        var alertTitle = ""
        var alertMessage = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertMessage = Constants.alertForCameraAccessMessage
            alertTitle = Constants.enableCamera
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertMessage = Constants.alertForPhotoLibraryMessage
            alertTitle = Constants.enablePhotoLibrary
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertMessage = Constants.alertForVideoLibraryMessage
            alertTitle = Constants.enableVideo
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: alertMessage, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive, handler: { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
}

//MARK: - IMAGE PICKER DELEGATE
 extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if picker.sourceType == .camera {
//
//            currentVC?.dismiss(animated: true, completion: nil)
//            if let image = info[.originalImage] as? UIImage {
//
//                var currentImage = image
//                if let compressedImage = self.compressImage(image) {
//                    currentImage = compressedImage
//                }
//                let fileName = MediaUtilities.shared.createCameraName()
//                let newImageUrl = MediaUtilities.shared.getTempDirectory().appendingPathComponent(fileName)
//                MediaUtilities.shared.saveImageToDirectory(currentImage, newImageUrl)
//
//                self.imagePickedBlock?(image,newImageUrl)
//            }
//          //  currentVC?.dismiss(animated: true, completion: nil)
//        }
//        else{
//
//            if let image = info[.originalImage] as? UIImage
//            {
////                print(image)
////                var imageURL : URL? = nil
////                if #available(iOS 11.0, *) {
////                    if let imageURL1 = info[.imageURL] as? URL {
////                        imageURL = imageURL1
////                    }
////                } else {
////                    if let imageURL1 = info[.referenceURL] as? URL {
////                        imageURL = imageURL1
////                    }
////                }
//                // self.compressAndEditImage(image, imageURL, picker)
//
//                var currentImage = image
//                if let compressedImage = self.compressImage(image) {
//                    currentImage = compressedImage
//                }
//                let fileName = MediaUtilities.shared.createCameraName()
//                let newImageUrl = MediaUtilities.shared.getTempDirectory().appendingPathComponent(fileName)
//                MediaUtilities.shared.saveImageToDirectory(currentImage, newImageUrl)
//
//
//                currentVC?.dismiss(animated: true, completion: nil)
//
//                self.imagePickedBlock?(currentImage,newImageUrl)
//               // currentVC?.dismiss(animated: true, completion: nil)
//            }
//            else if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
//                //Trying compression of video
//                print("File size before compression:",videoUrl.fileSizeString)
//                compressWithSessionStatusFunc(videoUrl)
//                currentVC?.dismiss(animated: true, completion: nil)
//            }
//            else{
//                currentVC?.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera {
            
            if let image = info[.originalImage] as? UIImage {
                
                var currentImage = image
                if let compressedImage = self.compressImage(image) {
                    currentImage = compressedImage
                }
                let fileName = MediaUtilities.shared.createNewImageFileName()
                let newImageUrl = MediaUtilities.shared.getTempDirectory().appendingPathComponent(fileName)
                MediaUtilities.shared.saveImageToDirectory(currentImage, newImageUrl)
                
                self.imagePickedBlock?(image,newImageUrl)
            }
            currentVC?.dismiss(animated: true, completion: nil)
        }
        else{
            
            if let image = info[.originalImage] as? UIImage
            {
                
                var imageURL : URL? = nil
                if #available(iOS 11.0, *) {
                    if let imageURL1 = info[.imageURL] as? URL {
                        imageURL = imageURL1
                    }
                } else {
                    if let imageURL1 = info[.referenceURL] as? URL {
                        imageURL = imageURL1
                    }
                }
                // self.compressAndEditImage(image, imageURL, picker)
                
                var currentImage = image
                
                
                if let compressedImage = self.compressImage(image) {
                    currentImage = compressedImage
                }
                
                if let finalImageUrl = imageURL {
                    
                    let newImageUrl = MediaUtilities.shared.getAttachmentHandlerImageFilePath(finalImageUrl.lastPathComponent)
                    MediaUtilities.shared.saveImageToDirectory(currentImage, newImageUrl)
                    self.imagePickedBlock?(currentImage,newImageUrl)
                }
                else{
                    let fileName = MediaUtilities.shared.createNewImageFileName()
                    let newImageUrl = MediaUtilities.shared.getTempDirectory().appendingPathComponent(fileName)
                    MediaUtilities.shared.saveImageToDirectory(currentImage, newImageUrl)
                    
                    self.imagePickedBlock?(currentImage,newImageUrl)
                }
                
                currentVC?.dismiss(animated: true, completion: nil)
            }
            else if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
                //Trying compression of video
                print("File size before compression:",videoUrl.fileSizeString)
                compressWithSessionStatusFunc(videoUrl)
                currentVC?.dismiss(animated: true, completion: nil)
            }
            else{
                currentVC?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: URL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        compressVideo(inputURL: videoUrl, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                
                DispatchQueue.main.async {
                    self.videoPickedBlock?(compressedURL)
                }
                
            case .failed:
                break
            case .cancelled:
                break
                
            @unknown default:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

//MARK: FILE IMPORT DELEGATE
 extension AttachmentHandler:  UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        currentVC?.dismiss(animated: true, completion: nil)
        if let firstUrl = urls.first {
            self.filePickedBlock?(firstUrl)
        }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: DSPhoto Editor SDK
//public extension AttachmentHandler : DSPhotoEditorViewControllerDelegate {
//
//    func compressAndEditImage(_ selectedImage:UIImage,_ imageUrl:URL,_ picker:UIImagePickerController?) {
//
//        if let dsPhotoEditorViewController = DSPhotoEditorViewController(image: selectedImage, apiKey: self.imageEditorApiKey, toolsToHide:[TOOL_PIXELATE]) {
//            dsPhotoEditorViewController.delegate = self
//            dsPhotoEditorViewController.view.layoutIfNeeded()
//
//            if let bottomView = dsPhotoEditorViewController.dsBottomContentView {
//            var hideIndexes = [Int]()
//            var index = 0
//            for case let button as UIButton in bottomView.subviews {
//                button.tag = index
//                index = index+1
//            }
//            index = 0
//            for case let label as UILabel in bottomView.subviews {
//                label.tag = index
//                index = index+1
//            }
//            for case let label as UILabel in bottomView.subviews {
//                if ["SDK"].contains(label.text) {
//                    hideIndexes.append(label.tag)
//                    label.isHidden = true
//                }
//            }
//            for case let button as UIButton in bottomView.subviews {
//                if hideIndexes.contains(button.tag) {
//                    button.isHidden = true
//                }
//            }
//        }
//            if picker == nil {
//                 self.currentVC?.present(dsPhotoEditorViewController, animated: true, completion: nil)
//            }else{
//                picker!.present(dsPhotoEditorViewController, animated: true, completion: nil)
//            }
//
//        }else
//        {
//           self.imagePickedBlock?(selectedImage,imageUrl)
//        }
//    }
//
//    func editImage(image:UIImage,imageUrl:String,controller:UIViewController) {
//
//        self.currentVC = controller
//        self.compressAndEditImage(image, imageUrl.toUrl, nil)
//    }
//
//    public func dsPhotoEditor(_ editor: DSPhotoEditorViewController!, finishedWith image: UIImage!) {
//        let fileName = MediaUtilities.createNewCameraRollImageFileName()
//        let newImageUrl = MediaUtilities.getDirectoryOfFile(fileName, 1)
//        MediaUtilities.saveImageToDirectory(image, newImageUrl)
//        self.imagePickedBlock?(image,newImageUrl)
//        currentVC?.dismiss(animated: true, completion: nil)
//    }
//
//    public func dsPhotoEditorCanceled(_ editor: DSPhotoEditorViewController!) {
//        currentVC?.dismiss(animated: true, completion: nil)
//    }
//}


public extension AttachmentHandler {
    
    func compressImage(_ image: UIImage) -> UIImage? {
        var actualHeight = Float(image.size.height )
    var actualWidth = Float(image.size.width)
        let maxHeight: Float = 1000.0
        let maxWidth: Float = 1000.0
    var imgRatio = actualWidth / actualHeight
    let maxRatio = maxWidth / maxHeight
    let compressionQuality: Float = 1.0 //50 percent compression

   if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        } else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        } else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }

        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
        guard let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality)) else { return nil }
    UIGraphicsEndImageContext()

    return UIImage(data: imageData)
        
    }
            
}


public extension String {
    func getNumbers() -> [NSNumber] {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let charset = CharacterSet.init(charactersIn: " ,.")
        return matches(for: "[+-]?([0-9]+([., ][0-9]*)*|[.][0-9]+)").compactMap { string in
            return formatter.number(from: string.trimmingCharacters(in: charset))
        }
    }

    // https://stackoverflow.com/a/54900097/4488252
    func matches(for regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }
        let matches  = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.compactMap { match in
            guard let range = Range(match.range, in: self) else { return nil }
            return String(self[range])
        }
    }
}

public extension UIImage {
    func getFileSizeInfo(allowedUnits: ByteCountFormatter.Units = .useMB,
                          countStyle: ByteCountFormatter.CountStyle = .file) -> String? {
         // https://developer.apple.com/documentation/foundation/bytecountformatter
         let formatter = ByteCountFormatter()
         formatter.allowedUnits = allowedUnits
         formatter.countStyle = countStyle
         return getSizeInfo(formatter: formatter)
     }

     func getFileSize(allowedUnits: ByteCountFormatter.Units = .useMB,
                      countStyle: ByteCountFormatter.CountStyle = .memory) -> Double? {
         guard let num = getFileSizeInfo(allowedUnits: allowedUnits, countStyle: countStyle)?.getNumbers().first else { return nil }
         return Double(truncating: num)
     }

     func getSizeInfo(formatter: ByteCountFormatter, compressionQuality: CGFloat = 1.0) -> String? {
         guard let imageData = jpegData(compressionQuality: compressionQuality) else { return nil }
         return formatter.string(fromByteCount: Int64(imageData.count))
     }
}

