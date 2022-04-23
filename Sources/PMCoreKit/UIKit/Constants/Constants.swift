

import Foundation




public class APIKeys {
    static let GoogleMapKey = "AIzaSyCqlxJEVnSMDQodgVH1IYZnZZUv3JoOpls"
}




public class Defaults {
    static let USER_NAME = "UserName"
    static let PASSWORD = "Password"
    static let ON_BOARDING = "Onboarding"
    static let LOGIN_ID = "LoginId"
    static let REM_PASSWORD = "Rem_Password"
    
    static let MAX_ALLOWED_GUESTS = "MaxAllowedGuests"
    static let APP_LAUNCHED = "Onboarding"
}


public class ContentTypes {
    static let TEXT = "Text"
    static let FILE = "File"
}

public class FileTypes {
    static let PLAIN = "plain"
    static let IMAGE = "image"
    static let AUDIO = "audio"
    static let VIDEO = "video"
    static let DOC = "doc"
    static let PDF = "pdf"
}



public class AppInfo {
    static let BUNDLE_ID = Bundle.main.bundleIdentifier ?? ""
}


public class Config {
    static let companyUrl = "http://www.gpinfotech.com"
}


public class ConstantType {
    public static let kemptyPassword = "Please enter password"
    public static let kEmptyUserName = "Please enter userName"
    public static let kValidDetails = "Please enter Valid Credentails"
    public static let kNetworkCheck = "Please Check your Network Connection"
    public static let kNetworkTitle = "No Internet Connection"
    public static let kServerAlert = "server is not responding"
    public static let kNetworkAlert = "Make sure your device is connected to the internet."
    public static let kSecurityEntity  = "SecurityEntity"
    public static let kMainEntity = "MainEntity"
    public static let kStatus = "Status"
    public static let kComments = "Comments"
    public static let kInvalidLogin = "Please enter valid credentials"
    public static let kOldPasswordTitle = "Incorrect password"
    public static let kIncorrectpassword = "This password is incorrect."
    public static let kPasswordResetAlert = "Password reset successfully"
    public static let kSamePassword = "Make sure new password should not same as old password"
    public static let kIncorrectOldPassword = "Old password is incorrect."
    
}
