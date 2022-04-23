//
//  UIKit+Extension.swift
//  GPKit
//
//  Created by sn99 on 28/03/22.
//

import Foundation
import UIKit


public extension UIApplication {
    /// - End editing / Keyboard editing
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
