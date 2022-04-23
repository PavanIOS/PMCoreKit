//
//  Colors.swift
//  bms_iOS
//
//  Created by Sekhar on 08/12/18.
//  Copyright © 2018 Sekhar n. All rights reserved.
//

import UIKit


public class Colors : UIColor {
    
    override public class var groupTableViewBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemGroupedBackground
        } else {
            return .groupTableViewBackground
        }
    }
    
    public override class var systemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    public override class var separator: UIColor {
        if #available(iOS 13, *) {
            return .separator
        } else {
            return .groupTableViewBackground
        }
    }
    
    
    
    
    public override class var systemRed: UIColor {
        if #available(iOS 13, *) {
            return .systemRed
        } else {
            return .red
        }
    }
    
    public override class var gray: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray
        }else{
            return .gray
        }
    }
    
    public override class var white: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        }else{
            return .white
        }
    }
    
    public override class var link: UIColor {
        if #available(iOS 13, *) {
            return .link
        } else {
            return .blue
        }
    }
    
    // Common
    static let navBarColor = "f7f7f7".color()
    static let def_blue = "007aff".color()
    static let unSelected_gray = "DDDDDD".color()
    static let disableColor = "F5F5F5".color()
    
    static let gpLogoColor = "021350".color()
    
    static let startGradient = "CEDFFF".color()
    static let endGradient = "E6EEFF".color()
    static let profileBg = "eff0f0".color()
    
}


public extension Colors {
  
    
    
    // These are common for each app
    static let themeBlack = UIColor.black
    static let themeColor = "1E656D".color()
    static let themeYellow = "FFA600".color()
    static let themeGreen = "1E656D".color() // "125B40".color()
    static let themeBgColor = "F2F7F6".color()
    
    
    // Messaging
    static let blue_Color = "8C36FB".color()
    static let shade_green = "00A8B2".color()
    static let green_color = "4CD964".color()
    static let dark_green = "008000".color()
    
//
//    static let navy = "000080".color()
//    static let floating_button_color = "1194ee".color()
//    static let view_line = "CECED2".color()
//    static let green_color = "4CD964".color()
//    static let dark_green = "008000".color()
//    static let edit_text_background = "EFEFF4".color()
//    static let span_piers_color = "d3e0e2".color()
//    static let navigation_background_color = "263238".color()
//    static let dark_yellow = "FFFF33".color()
//    static let condition_color = "323C5A".color()
//    static let condition_orange = "FFA500".color()
//    static let list_color = "007E6A".color()
//    static let light_yellow = "F6AA22".color()
//    static let tab_search_roads_color = "7A7A7A".color()
//    static let profile_line_color = "474747".color()
//    static let listview_text_color = "1f1f1f".color()
//    static let hint_color = "878787".color()
//    static let side_navigation_line_color = "1D2428".color()
    
//    static let calculatorNumbers = "EBEBEB".color()
//    static let calculatorOptions = "FF9100".color()
//    static let sky_blue = "0089FF".color()
    
//    static let normal_white = "eef5f5".color()
//    static let light_white = "f2f2f2".color()
//    static let light_green = "50ae55".color()
//    static let light_orange = "d6ad16".color()
//    static let linen_white = "FAF0E6".color()
//    static let reports_text_color = "2196f3".color()
//
//    static let light_white_gray = "fafafa".color()
//    static let dark_gray_color = "474747".color()
//    static let bg_green = "4caf50".color()
//    static let normal_black = "404040".color()
//    static let light_black = "494949".color()
//    static let spinner_background = "292929".color()
//
//    static let yellowRed_color = "E8B321".color()
//    static let orange_color = "E99939".color()
//    static let instructions_color = "3A99D8".color()
//    static let view_shift_reports_color = "e47e30".color()
//    static let bg_color = "e61b0a".color()
//    static let divider_color = "C0C0C0".color()
//
    
    
    static let summative_assessments = UIColor(hex: "A06BBD")
    static let assignments = UIColor(hex: "31689D")
    static let finance = UIColor(hex: "8DBFCA")
    static let work_shop = UIColor(hex: "F9CB73")
    static let general = UIColor(hex: "FFB8A4")
    static let registration = UIColor(hex: "34C385")
    
  
    
  //  static let theme_app_Color = "1E656D".color()
    
  
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
         //  print(hexString)
           return hexString
        
//        var r:CGFloat = 0
//        var g:CGFloat = 0
//        var b:CGFloat = 0
//        var a:CGFloat = 0
//        getRed(&r, green: &g, blue: &b, alpha: &a)
//        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
//        return String(format:"#%06x", rgb)
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
        return .black // Return a default colour
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
    
    func color() -> UIColor {
        return UIColor(hex: self)
    }
}
