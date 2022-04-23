//
//  Utilities.swift
//  ShiftBoss
//
//  Created by pavan M. on 4/24/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI



public enum AlertType : String
{
    case Normal
    case POPNAVIGATION
}
public enum ActionSheetType : String {
    case Normal
}

public class CommonAlertView : NSObject {
    static let shared = CommonAlertView()
    
    let newLine = "\n"
    
    var alertView = UIAlertController()
    
    private override init(){
        
    }
    
    func showAlert(_ title: String,_ message:String? = nil,_ alertType:AlertType = .Normal,_ actions:[UIAlertAction]? = nil) {
        Spinner.HideLoading()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actionItems = actions {
            for actionItem in actionItems {
                alertController.addAction(actionItem)
            }
        }else{
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
       
        if title != "" || message != nil {
            
            if let topView = UIApplication.topViewController() {
                if !topView.isKind(of: UIAlertController.self) {
                    topView.present(alertController, animated: true, completion: nil)
                }
            }
        }

    }
    
    func showImageAlert(_ title:String,_ message:String? = nil,_ image:UIImage,_ circle:Bool = false,_ actions:[UIAlertAction]? = nil) {
        Spinner.HideLoading()
        let message1 =  "\(message ?? "")\(newLine + newLine+newLine+newLine+newLine+newLine+newLine)"
        var title1 = title
        
        if title != "" {
           title1 = title + newLine + newLine
        }
        
        let alertController = UIAlertController(title: title1, message: message1, preferredStyle: .alert)
        
        let imageSize : CGFloat = 100
        let alertFrame = alertController.view.frame
        let imageView = CustomImageView(frame: CGRect(x: alertFrame.width/2-imageSize, y: 100, width: imageSize, height: imageSize))
        if circle {
            imageView.setCircle()
        }
        // imageView.contentMode = .center
        imageView.image = image
        
        alertController.view.addSubview(imageView)
        
        //        let height = NSLayoutConstraint(item: alertController.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageSize + 150)
        //                 let width = NSLayoutConstraint(item: alertController.view as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        //  alertController.view.addConstraint(height)
        // alertController.view.addConstraint(width)
        
        if let actionItems = actions {
            for actionItem in actionItems {
                alertController.addAction(actionItem)
            }
        }else{
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        
        if title != "" || message1 != "" {
            
            if let topView = UIApplication.topViewController() {
                if !topView.isKind(of: UIAlertController.self) {
                    topView.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    func showActionSheet(_ title: String,_ message:String? = nil,_ actions:[UIAlertAction]? = nil,_ actionsheetType:ActionSheetType = .Normal,_ sender:UIView,_ senderFrame:CGRect) {
        Spinner.HideLoading()
        
        var alertTitle : String? = nil
        var alertMessage : String? = nil
        
        if title != "" {
            alertTitle = title
        }
        if message != "" {
            alertMessage = message
        }
        
        
        let actionSheetController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .actionSheet)
        
        if let actionItems = actions {
            for actionItem in actionItems {
                actionSheetController.addAction(actionItem)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheetController.addAction(cancelAction)
        }else{
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheetController.addAction(cancelAction)
        }
        
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.midY, width: 0, height: 0)
        }
        
        UIApplication.topViewController()?.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func showVerificationTextField(_ title: String,_ message:String? = nil,_ actions:[UIAlertAction]? = nil,_ limit:Int = 6){
        Spinner.HideLoading()
        
        //  var allTextFields = textFields
        alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        alertView.addTextField { (textField) in
            textField.keyboardType = .numberPad
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            textField.delegate = self
            textField.tag = limit
            textField.textAlignment = .center
            textField.placeholder = "Code"
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            } else {
            }
            textField.font = UIFont.boldSystemFont(ofSize: 20)
            textField.becomeFirstResponder()
            textField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        }
        
        
        if let actionItems = actions {
            for actionItem in actionItems {
                alertView.addAction(actionItem)
            }
        }else{
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
        }
        
        
        if title != "" || message != nil {
            UIApplication.topViewController()?.present(alertView, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func textFieldDidChange() {
        var isEmpty = false
        if let textFields = alertView.textFields {
            for textField in textFields {
                if textField.text!.isEmpty {
                    isEmpty = true
                }
            }
        }
        alertView.actions.first(where: {$0.title?.lowercased() == "submit"})?.isEnabled = !isEmpty
    }
    
    
    
}

 extension CommonAlertView : UITextFieldDelegate{

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = textField.tag
        if  textField.keyboardType == .numberPad {
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
        }
        if let text = textField.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if maxLength > 0, maxLength < finalText.utf8.count {
                return false
            }
        }
        return true
    }
}


public class TextViewAlertController: UIAlertController,UITextViewDelegate {
    
    var textChangedBlock : ((UITextView) -> Void)?
    var maxLength = 0
    var countlbl = CustomLabel()
    
    let textView: UITextView = {
        let view = UITextView(frame: CGRect.zero)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    var keyboardHeight: CGFloat = 100 {
        didSet {
            let height = UIScreen.main.bounds.height
            let menu = self.view.frame.height
            let keyb = self.keyboardHeight
            self.view.frame.origin.y = height-menu-keyb-20
        }
    }
    convenience init(title: String,message:String) {
        self.init(title: title + "\n\n\n\n\n\n", message: "", preferredStyle: .alert)
    }
    public override var preferredStyle: UIAlertController.Style {
        return .alert
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        view.addSubview(textView)
        [textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
         textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
         textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 54),
         textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -74)].forEach({ $0.isActive = true })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(sender:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let textViewFrame = textView.frame
        countlbl.frame = CGRect(x: textViewFrame.origin.x, y: textViewFrame.height+10, width: textViewFrame.width, height: 20)
        countlbl.textColor = .gray
        countlbl.font = UIFont.systemFont(ofSize: 15)
        countlbl.textAlignment = .right
        if maxLength > 0 {
            countlbl.text = "\(maxLength)"
            view.addSubview(countlbl)
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
        let textViewFrame = textView.frame
        countlbl.frame = CGRect(x: textViewFrame.origin.x, y: textViewFrame.origin.y + textViewFrame.height+5, width: textViewFrame.width, height: 20)
        UIView.animate(withDuration: 0.3) {
            let height = UIScreen.main.bounds.height
            let menu = self.view.frame.height
            let keyb = self.keyboardHeight
            self.view.frame.origin.y = height-menu-keyb-20
        }
    }
    @objc func keyboardChange(sender: Notification) {
        guard let userInfo = sender.userInfo else { return }
        let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        keyboardHeight = endFrame?.height ?? 100
    }
    
    
    public func textViewDidChange(_ textView: UITextView) {
        self.textChangedBlock?(textView)
        if maxLength > 0 {
            countlbl.text = "\(maxLength - textView.text.count)"
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let finalText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if maxLength > 0, maxLength < finalText.utf8.count {
            return false
        }
        return true
    }
    
}
