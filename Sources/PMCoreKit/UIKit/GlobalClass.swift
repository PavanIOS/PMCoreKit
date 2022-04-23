//
//  GlobalClass.swift
//  Regent
//
//  Created by sn99 on 19/01/21.
//  Copyright © 2021 sn99. All rights reserved.
//

import Foundation
import UIKit




// Safe area
var topPadding : CGFloat = 0.0
var bottomPadding : CGFloat = 0.0
var realmVersion : UInt = 1


 //MARK: - Get app current version
public func getAppVersion() -> String {
       let version = Bundle.main.version
    //   let build = Bundle.main.build
       let urlHint = NetworkUrls.URL_HINT
       return "Ver \(version)_\(realmVersion)(\(urlHint))"
   }


//MARK: - Get Label Height
public func heightForLabel(_ text:String,_ font:UIFont,_ width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}



func isfirstTimeLaunch() -> Bool {
    if !UserDefaults.standard.bool(forKey: Defaults.APP_LAUNCHED) {
        UserDefaults.standard.set(true, forKey: Defaults.APP_LAUNCHED)
        UserDefaults.standard.synchronize()
        return true
    }
    return false
}


func isLoggedInAlready() -> Bool {
    
    if let loginId = UserDefaults.standard.string(forKey: Defaults.LOGIN_ID), let userName = UserDefaults.standard.string(forKey: Defaults.USER_NAME), let password = UserDefaults.standard.string(forKey: Defaults.PASSWORD) {
        
        if !loginId.isEmpty && !userName.isEmpty && !password.isEmpty {
            return true
        }
    }
    
    let authData = AuthenticationDataStore().getData()
    
    if !authData.studentId.isEmpty && !authData.customerPassword.isEmpty {
        return true
    }
    
    
    return false
}


func clearLoggedInData(){
    UserDefaults.standard.removeObject(forKey: Defaults.LOGIN_ID)
    UserDefaults.standard.removeObject(forKey: Defaults.USER_NAME)
    UserDefaults.standard.removeObject(forKey: Defaults.PASSWORD)
}




func getWebImagePath(_ filePath:String) -> String {
    if filePath.starts(with: "http") {
        return filePath
    }
    else{
        return NetworkUrls.Download_Base_Url + filePath
    }
}