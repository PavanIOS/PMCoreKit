//
//  Labels.swift
//  Event Management
//
//  Created by sn99 on 17/07/21.
//

import Foundation
import SwiftUI


struct CompanyNameLbl : View {
    
    var companyName = ""
    
    var body: some View {
        
            Text("A product of \(companyName)").frame(maxWidth: .infinity,alignment: .center)
    }
    
}
