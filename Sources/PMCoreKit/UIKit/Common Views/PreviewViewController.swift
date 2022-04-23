//
//  PreviewViewController.swift
//  GpHealthPlus
//
//  Created by sn99 on 09/04/20.
//

import UIKit
import QuickLook

class PreviewViewController: QLPreviewController {
    
      var previewUrls = [URL]()
    
    
     func isModal() -> Bool {
          return self.presentingViewController?.presentedViewController == self
              || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
              || self.tabBarController?.presentingViewController is UITabBarController
      }
      
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
          // Do any additional setup after loading the view.
          
         // self.dataSource = self
          if isModal() {
              self.setupBarButtons()
          }else{
              setBackButtonTitle(text: "Back", color: .black)
          }
      }
      
      public func setBackButtonTitle(text:String? = nil,color:UIColor? = nil){
          let backButton = UIBarButtonItem()
          if text != nil {
              backButton.title = text
          }
          if color != nil {
              backButton.tintColor = color
          }
          self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
      }
      
      override func viewDidAppear(_ animated: Bool) {
             super.viewDidAppear(animated)
           if !isModal() {
                 let textAttributes = [NSAttributedString.Key.foregroundColor:Colors.black]
                 self.navigationController?.navigationBar.titleTextAttributes = textAttributes
            self.navigationController?.navigationBar.tintColor = .black
          }
         }

         override func viewWillDisappear(_ animated: Bool) {
             super.viewWillDisappear(animated)
           if !isModal() {
             let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
             self.navigationController?.navigationBar.titleTextAttributes = textAttributes
            self.navigationController?.navigationBar.tintColor = .white
          }
         }
      
      
      func setupBarButtons(){
          var closeButton = UIBarButtonItem()
          if #available(iOS 13.0, *) {
              closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.dismissView))
          } else {
              closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissView))
              closeButton.tintColor = UIColor.systemBlue
          }
          self.navigationItem.leftBarButtonItem = closeButton
      }
      
      @objc func dismissView(sender:UIBarButtonItem) {
          self.dismiss(animated: true, completion: nil)
      }
      
      
    
}

extension PreviewViewController : QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewUrls.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let currentItem = previewUrls[index]
        return currentItem as QLPreviewItem
    }
}

