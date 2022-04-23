//
//  CustomFonts.swift
//  INCEIS
//
//  Created by sn99 on 29/06/20.
//

import Foundation
import UIKit

public class CustomFonts {
    
    
    enum FontSizes : CGFloat {
        case LOW = 10.0
        case SHORT = 12.0
        case NORMAL = 15.0
        case MEDIUM = 17.0
        case LONG = 20.0
        case HEAVY = 23.0
        
    }
    
    
    
    static let REGULAR : UIFont.Weight = .regular
    static let MEDIUM : UIFont.Weight = .medium
    static let SEMI_BOLD : UIFont.Weight = .semibold
    static let BOLD : UIFont.Weight = .bold
    
    
    
    
    static func getCustomFontSize(_ size:CGFloat) -> FontSizes {
        let fontSize = CustomFonts.FontSizes(rawValue: size) ?? FontSizes.MEDIUM
        return fontSize
    }
    
    static func getRegularFont(_ size:FontSizes = .MEDIUM) -> UIFont{
        return UIFont.systemFont(ofSize: size.rawValue, weight: REGULAR)
    }
    
    static func getMediumFont(_ size:FontSizes = .MEDIUM) -> UIFont{
        return UIFont.systemFont(ofSize: size.rawValue, weight: MEDIUM)
    }
    
    static func getBoldFont(_ size:FontSizes = .MEDIUM) -> UIFont{
        return UIFont.systemFont(ofSize: size.rawValue, weight: BOLD)
    }
    
    static func getSemiBoldFont(_ size:FontSizes = .MEDIUM) -> UIFont{
        return UIFont.systemFont(ofSize: size.rawValue, weight: SEMI_BOLD)
    }
    
   
    
    
    
    static let Form_Normal_Title = getMediumFont(.NORMAL)
    static let Form_Normal_Value = getMediumFont(.MEDIUM)
    
    
}


extension CustomFonts {
    /*
    HelveticaNeue
    HelveticaNeue-Bold
    HelveticaNeue-BoldItalic
    HelveticaNeue-CondensedBlack
    HelveticaNeue-CondensedBold
    HelveticaNeue-Italic
    HelveticaNeue-Light
    HelveticaNeue-LightItalic
    HelveticaNeue-Medium
    HelveticaNeue-MediumItalic
    HelveticaNeue-Thin
    HelveticaNeue-ThinItalic
    HelveticaNeue-UltraLight
    HelveticaNeue-UltraLightItalic
 
 */
    
    
    
    /*
    Krungthep
    Krungthep-Bold
    Krungthep-BoldItalic
    Krungthep-CondensedBlack
    Krungthep-CondensedBold
    Krungthep-Italic
    Krungthep-Light
    Krungthep-LightItalic
    Krungthep-Medium
    Krungthep-MediumItalic
    Krungthep-Thin
    Krungthep-ThinItalic
    Krungthep-UltraLight
    Krungthep-UltraLightItalic
 
 */
    
    
    
    static func getHelveticaNeueRegularFont(_ size:FontSizes = .MEDIUM) -> UIFont{
        if let font = UIFont(name: "HelveticaNeue", size: size.rawValue){
            return font
        }
        return UIFont.systemFont(ofSize: size.rawValue, weight: REGULAR)
    }
    
    static func getHelveticaNeueMediumFont(_ size:FontSizes = .MEDIUM) -> UIFont{
        if let font = UIFont(name: "HelveticaNeue-Medium", size: size.rawValue){
            return font
        }
        return UIFont.systemFont(ofSize: size.rawValue, weight: MEDIUM)
    }
    
    
    static func getHelveticaNeueBoldFont(_ size:FontSizes = .MEDIUM) -> UIFont{
        if let font = UIFont(name: "HelveticaNeue-Bold", size: size.rawValue){
            return font
        }
        return UIFont.systemFont(ofSize: size.rawValue, weight: REGULAR)
    }
    
}




// This app Fonts
public extension CustomFonts {
    static let Regular_10 = getRegularFont(.LOW)
    static let Regular_12 = getRegularFont(.SHORT)
    static let Regular_15 = getRegularFont(.NORMAL)
    static let Regular_17 = getRegularFont(.MEDIUM)
    static let Regular_20 = getRegularFont(.LONG)
    static let Regular_23 = getRegularFont(.HEAVY)
    
    static let Medium_10 = getMediumFont(.LOW)
    static let Medium_12 = getMediumFont(.SHORT)
    static let Medium_15 = getMediumFont(.NORMAL)
    static let Medium_17 = getMediumFont(.MEDIUM)
    static let Medium_20 = getMediumFont(.LONG)
    static let Medium_23 = getMediumFont(.HEAVY)
    
    static let Semi_Bold_10 = getSemiBoldFont(.LOW)
    static let Semi_Bold_12 = getSemiBoldFont(.SHORT)
    static let Semi_Bold_15 = getSemiBoldFont(.NORMAL)
    static let Semi_Bold_17 = getSemiBoldFont(.MEDIUM)
    static let Semi_Bold_20 = getSemiBoldFont(.LONG)
    static let Semi_Bold_23 = getSemiBoldFont(.HEAVY)
    
    static let Bold_10 = getBoldFont(.LOW)
    static let Bold_12 = getBoldFont(.SHORT)
    static let Bold_15 = getBoldFont(.NORMAL)
    static let Bold_17 = getBoldFont(.MEDIUM)
    static let Bold_20 = getBoldFont(.LONG)
    static let Bold_23 = getBoldFont(.HEAVY)
}
