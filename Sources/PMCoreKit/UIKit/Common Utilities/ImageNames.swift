//
//  ImageNames.swift
//  ShiftBoss
//
//  Created by sn99 on 17/04/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import Accelerate

class ImageNames {
    
    static func getImage(_ name:String) -> UIImage {
        return UIImage(named:name) ?? UIImage()
    }
    
    static func getSystemImage(_ name:String) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: name)
        } else {
            return nil
        }
    }
    
    
    
    // Common
    static let emptyImage = UIImage()
    let empty = UIImage()
   
    static let backArrow = "backArrow".image()
    static let hidePassword = "hidePassword".image()
    static let showPassword = "showPassword".image()
    static let back = "back".image()
    static let checkbox = "checkbox".image()
    static let uncheck = "uncheck".image()
    static let downArrow = "downArrow".image()
    static let expand = "expand".image()
    static let forward = "forward".image()
    static let mandatory = "mandatory".image()
    static let notifications = "notifications".image()
    static let settings = "settings".image()
    static let forgotPassword = getImage("forgotPassword")
    static let radiobutton = "radiobutton".image()
    static let radiobuttonOff = "radiobuttonOff".image()
    static let logout = "logout".image()
    
}

extension ImageNames {
   
    
    static let home = "home_icon".image()
    
    static let IdVerify = getImage("IdVerify")
    static let report = getImage("report")
    
    static let upload = getImage("upload")
    static let uploadNew = getImage("uploadNew")
    
    
    
    static let rightArrowLine = "rightArrowLine".image()
    
    // Home
    static let document = getImage("document")
    static let ER = getImage("ER")
    static let news = getImage("news")
    static let NOT = getImage("NOT")
    static let OSA = getImage("OSA")
    static let PRA = getImage("PRA")
    static let RAQ = getImage("RAQ")
    static let RQ = getImage("RQ")
    
    //Logo
    static let gpit_logo = getImage("gpit_logo")
    static let intro_image_1 = getImage("intro_image_1")
    static let intro_image_2 = getImage("intro_image_2")
    static let login_bg = getImage("login_bg")
    static let mancosa_new_logo = getImage("mancosa_new_logo")
    
    
    //Notifications
    static let Exams = getImage("Exams")
    static let finance = getImage("finance")
    static let general = getImage("general")
    static let registrations = getImage("registrations")
    static let workshops = getImage("workshops")
    static let assignments = getImage("assignments")
    
    
    static let Queries = "Queries".image()
    static let ExamModule = "ExamModule".image()
    static let seat = "seat".image()
    
    
    // Messaging
    static let checkmark = "checkmark".image()
    static let double_tick = "double_tick".image()
    static let download = "download".image()
    static let square_clock = "square_clock".image()
    static let double_down = "double_down".image()
    static let chat = "chat".image()
    static let ic_action_attach_file = "ic_action_attach_file".image()
    
    
    
    //Auth module
    static let verified = "verified".image()
    static let ic_action_camera = "ic_action_camera".image()
    static let right_pointing_icon = "right_pointing_icon".image()
    static let galleryPlaceHolder = "GalleryPlaceHolder".image()
    
    
    
    //Version 1.0
    static let assessment = "assessment".image()
    static let documents = "documents".image()
    static let graduation = "graduation".image()
    static let graphic = "graphic".image()
    static let home_icon = "home_icon".image()
    static let news_icon = "news_icon".image()
    static let notifications_icon = "notifications_icon".image()
    static let online = "online".image()
    static let profile = "profile".image()
    static let raised = "raised".image()
    static let settings_icon = "settings_icon".image()
    static let tile1 = "tile1".image()
    static let tile2 = "tile2".image()
    static let tile3 = "tile3".image()
    static let tile4 = "tile4".image()
    static let tile5 = "tile5".image()
    static let tile6 = "tile6".image()
    
    
    static let aboutapp = "aboutapp".image()
    static let help = "help".image()
    static let language = "language".image()
    static let light = "light".image()
    static let notifications_ic = "notifications_ic".image()
    static let password = "password".image()
    static let pay = "pay".image()
    static let university = "university".image()
    
    static let ic_action_event = "ic_action_event".image()
    static let ic_action_document = "ic_action_document".image()
    static let delete = "delete".image()
    static let add = "add".image()
    static let icon_delete = "icon_delete".image()
    
}






extension UIImage {
    
    func maskWithColor(_ color: UIColor) -> UIImage {
        
        if #available(iOS 13.0, *) {
            return self.withTintColor(color)
        } else {
            
            
            if let maskImage = cgImage {
                let width = size.width
                let height = size.height
                let bounds = CGRect(x: 0, y: 0, width: width, height: height)
                
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
                let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
                
                context.clip(to: bounds, mask: maskImage)
                context.setFillColor(color.cgColor)
                context.fill(bounds)
                
                if let cgImage = context.makeImage() {
                    let coloredImage = UIImage(cgImage: cgImage)
                    return coloredImage
                } else {
                    return self
                }
            }else{
                return self
            }
        }
        
    }
    
    class func pixelImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
    
    func scale(scale: CGFloat) -> UIImage? {
        let size = self.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return self.resize(targetSize: scaledSize)
    }
    
    
    
}



extension String {
    func image() -> UIImage {
        return UIImage(named:self) ?? UIImage()
    }
}
