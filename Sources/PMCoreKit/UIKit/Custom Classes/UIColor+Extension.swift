//
//  UIColor.swift
//  bms_iOS
//
//  Created by Sekhar on 08/12/18.
//  Copyright © 2018 Sekhar n. All rights reserved.
//

import UIKit


extension UIColor {
    
    public static var groupTableViewBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemGroupedBackground
        } else {
            return .groupTableViewBackground
        }
    }
    
    public static var systemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    public static var separator: UIColor {
        if #available(iOS 13, *) {
            return .separator
        } else {
            return .groupTableViewBackground
        }
    }
    
    
    public static var systemRed: UIColor {
        if #available(iOS 13, *) {
            return .systemRed
        } else {
            return .red
        }
    }
    
    public static var gray: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray
        }else{
            return .gray
        }
    }
    
    public static var white: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        }else{
            return .white
        }
    }
    
    public static var link: UIColor {
        if #available(iOS 13, *) {
            return .link
        } else {
            return .blue
        }
    }
    
    // Common
    public static let navBarColor = "f7f7f7".toUIcolor()
    public static let def_blue = "007aff".toUIcolor()
    public static let unSelected_gray = "DDDDDD".toUIcolor()
    public static let disableColor = "F5F5F5".toUIcolor()
    
    public static let gpLogoColor = "021350".toUIcolor()
    
    public static let startGradient = "CEDFFF".toUIcolor()
    public static let endGradient = "E6EEFF".toUIcolor()
    public static let profileBg = "eff0f0".toUIcolor()
    
    
    public static let themeColor = "f7f7f7".toUIcolor()
    
}



//MARK: - public extensions
public extension UIColor {
    
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
    
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    public func toHexString() -> String {
        
        let components = self.cgColor.components
           let r: CGFloat = components?[0] ?? 0.0
           let g: CGFloat = components?[1] ?? 0.0
           let b: CGFloat = components?[2] ?? 0.0

           let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
           return hexString
    }
    
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    func inverseColor() -> UIColor {
        var alpha: CGFloat = 1.0
        
        var white: CGFloat = 0.0
        if self.getWhite(&white, alpha: &alpha) {
            return UIColor(white: 1.0 - white, alpha: alpha)
        }
        
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
        }
        
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
        }
        
        return self
    }
    
    func inverse() -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        return .black
    }
    
    func getComplementaryForColor() -> UIColor {
        
        let ciColor = CIColor(color: self)
        
        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }
}


public extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}


public extension String {
    
    func toUIcolor() -> UIColor {
        return UIColor(hex: self)
    }
}
