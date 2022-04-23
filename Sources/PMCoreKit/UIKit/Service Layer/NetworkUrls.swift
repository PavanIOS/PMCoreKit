//
//  NetworkUrls.swift
//
//  Created by Pavan on 25/04/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import Foundation
import UIKit





enum EnvironmentType {
    case DEV
    case TESTING
    case RELEASE
    case SA_129
}


let currentEnvironment : EnvironmentType = .DEV
class NetworkUrls {
    
  
    
    private static var SERVER_PRO_BASE_URL : String {
            switch currentEnvironment {
            case .DEV:
                return "http://hyd.gpinfotech.com/"
            case .TESTING:
                return "http://hyd.gpinfotech.com/"
            case .RELEASE:
                return "http://hyd.gpinfotech.com/"
            case .SA_129:
                return "http://129.232.236.170/"
            }
        }
        
        private static var SERVER_PRO_URL_HINT : String {
            switch currentEnvironment {
            case .DEV:
                return "H"
            case .TESTING:
                return "H"
            case .RELEASE:
                return "L"
            case .SA_129:
                return "SA"
            }
        }
    

  
    /// -
    static let SERVER_PRO_DATA_LINK = "SMISEPAMAPI/api/"
    static let SERVER_PRO_MEDIA_UPLOAD_LINK = "SMISEPAMAPI/api/"
    static let SERVER_PRO_MEDIA_DOWNLOAD_LINK = "SMISAPIQA/"
   /// -
    
    
    
    static let URL_HINT = SERVER_PRO_URL_HINT
    static let Base_Url = SERVER_PRO_BASE_URL + SERVER_PRO_DATA_LINK
    static let Image_Base_Url = SERVER_PRO_BASE_URL + SERVER_PRO_MEDIA_UPLOAD_LINK
    static let Download_Base_Url = SERVER_PRO_BASE_URL + SERVER_PRO_MEDIA_DOWNLOAD_LINK
    
}

