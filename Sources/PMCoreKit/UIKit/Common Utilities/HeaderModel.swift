//
//  HeaderModel.swift
//  MuvyrDriver
//
//  Created by sn99 on 15/03/21.
//  Copyright © 2021 Gpinfotech. All rights reserved.
//

import Foundation



public class HeaderModel {
    var comments = ""
    var status = ""
    var UTCTimeStamp = ""
    var webAppUrl = ""
    
    

    func isSuccess() -> Bool {
        return self.status == "0" ? true : false
    }
    
}
