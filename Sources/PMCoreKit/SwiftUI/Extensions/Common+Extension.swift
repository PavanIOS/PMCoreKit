//
//  Common+Extension.swift
//  Event Management
//
//  Created by sn99 on 17/07/21.
//

import Foundation
import UIKit



extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


