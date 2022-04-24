

import Foundation





public class UserDefaultsKeys {
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


public class AlertMessages {
    public static let empty_password = "Please enter password"
    public static let empty_userName = "Please enter userName"
    public static let valid_credentials = "Please enter Valid Credentails"
    public static let internet_connection = "Please Check your Network Connection"
    public static let no_internet = "No Internet Connection"
    public static let server_error = "Server is not responding"
    public static let check_internet = "Make sure your device is connected to the internet."
    public static let incorrect_password = "Incorrect Password"
    public static let password_reset_done = "Password reset successfully"
    public static let password_not_match = "Make sure new password should not same as old password"
    public static let incorrect_old_password = "Old password is incorrect."
    
}
