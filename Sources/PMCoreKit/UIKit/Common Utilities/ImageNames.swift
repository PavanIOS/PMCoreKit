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

public class ImageNames {
    
    static func getImage(_ name:String) -> UIImage {
        return UIImage(named:name) ?? UIImage()
    }
    
//    static func getSystemImage(_ name:String) -> UIImage? {
//        if #available(iOS 13.0, *) {
//            return UIImage(systemName: name)
//        } else {
//            return nil
//        }
//    }
//
//
    
    // Common
    static let emptyImage = UIImage()
    let empty = UIImage()
   
    static let back = "back".image()
    static let downArrow = "downArrow".image()
    static let mandatory = "mandatory".image()
    static let forgotPassword = "forgotPassword".image()
    static let radiobutton = "radiobutton".image()
    static let radiobuttonOff = "radiobuttonOff".image()
    static let logout = "logout".image()
    static let logout = "Up Arrow".image()
    
}






public extension UIImage {
    
    func maskWithColor(_ color: UIColor) -> UIImage {
        
        if #available(iOS 13.0, *) {
            return self.withTintColor(color)
        } else {
            
            
            if let maskImage = cgImage {
                let width = size.width
                let height = size.height
                let bounds = CGRect(x: 0, y: 0, width: width, height: height)
                
                let UIColorpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
                let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: UIColorpace, bitmapInfo: bitmapInfo.rawValue)!
                
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
    
    public class func pixelImageWithColor(color: UIColor) -> UIImage {
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



public extension String {
    func image() -> UIImage {
        return UIImage(named:self) ?? UIImage()
    }
}
