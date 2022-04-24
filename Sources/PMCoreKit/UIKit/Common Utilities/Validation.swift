//
//  Validation.swift
//  EveryBooking
//
//  Created by sn99 on 24/02/20.
//

import Foundation
import UIKit

public class Validation {
    
    static func isReachable(_ showAlert:Bool = true) -> Bool{
        guard NetworkManager.shared.isReachable() else {
            if showAlert {
                CommonAlertView.shared.showAlert(AlertMessages.check_internet)
            }
            return false
        }
        return true
    }
    
     static func getTextFields(view:UIView) -> [CustomTextField]{
        var allFields = view.getAllSubviewsWithType() as [CustomTextField]
        allFields = allFields.filter({$0.isMandatory == true && $0.isEnabled == true})
        return allFields
    }
    
    private static func validateFields(_ textFields:[CustomTextField]) -> (textField:CustomTextField?,status:Bool) {
        if let emptyField = textFields.first(where: {$0.text == ""}) {
            return (emptyField,false)
        }
        return(nil,true)
    }
    
    static func validateTextFields(view:UIView) -> (textField:CustomTextField?,status:Bool) {
        let allFields = getTextFields(view: view)
        return self.validateFields(allFields)
    }
    
    static func validateAllEmptyFields(_ view:UIView) -> Bool {
        let invalidFields = Validation.validateTextFields(view: view)
        if let emptyTF = invalidFields.textField {
            if let placeHolder = emptyTF.placeholder {
                CommonAlertView.shared.showAlert("Please fill \(placeHolder)")
            }else{
                CommonAlertView.shared.showAlert("Please fill data")
            }
            return false
        }
        return true
    }
    
        
}
