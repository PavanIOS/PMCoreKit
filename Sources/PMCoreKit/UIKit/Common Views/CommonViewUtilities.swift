//
//  CommonViewUtilities.swift
//  GpHealthPlus
//
//  Created by sn99 on 22/05/20.
//

import Foundation
import UIKit


class CommonViewUtilities {
    
    static func loadAutoCompleteView(_ view:UIViewController,_ list:[OrderedDictionaryModel],_ isMultiSelection:Bool,_ title:String,_ maximumLimit:Int = 0,completion: @escaping (String,[OrderedDictionaryModel]) -> Void){
        
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        let autoCompleteView = storyboard.instantiateViewController(withIdentifier: "AutoCompleteView") as! AutoCompleteView
        autoCompleteView.autoCompleteData = list
        autoCompleteView.isMultiSelection = isMultiSelection
        autoCompleteView.title = title
        autoCompleteView.maximumLimit = maximumLimit
        if #available(iOS 13.0, *) {
            autoCompleteView.isModalInPresentation = true
        }
        autoCompleteView.autoCompletionBlock = {(result,selectedList) in
            var selectedValue = result
            if isMultiSelection {
                selectedValue = (selectedList.map{$0.value}).joined(separator: ",")
            }else{
                if let firstItem = selectedList.first {
                    selectedValue = firstItem.value
                }else{
                    selectedValue = result
                }
            }
            completion(selectedValue,selectedList)
        }
        let rootView = UINavigationController(rootViewController: autoCompleteView)
        view.present(rootView, animated: true, completion: nil)
    }
    
    
    
    static func openWebView(_ url:String,_ title:String,_ vc:UIViewController?) {
        var finalvc = vc
        if finalvc == nil {
            finalvc = UIApplication.topViewController()
        }
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        
        let webView = storyboard.instantiateViewController(withIdentifier: "CommonWebView") as! CommonWebView
        webView.webUrl = url
        webView.title = title
        let rootView = UINavigationController(rootViewController: webView)
        finalvc?.present(rootView, animated: true, completion: nil)
    }
    
    
    static func loadPopOverView(_ view:UIViewController,_ sourceView:UIView,_ isSelection:Bool = true,_ isMultiSelection:Bool = false,_ list:[OrderedDictionaryModel],_ selList:[OrderedDictionaryModel]? = nil,completion: @escaping ([OrderedDictionaryModel]) -> Void){
        let controller = PopOverViewController()
        controller.onSelect = { selectedObject in
            completion(selectedObject)
        }
        controller.autoCompleteData = list
        controller.isSelection = isSelection
        controller.isMultiSelection = isMultiSelection
        if let selList1 = selList {
            controller.selectedList = selList1
        }
       // controller.preferredContentSize = CGSize(width: 250, height: list.count*50)
        showPopup(controller, sourceView: sourceView,view)
    }
    
    private static func showPopup(_ controller: UIViewController, sourceView: UIView,_ presentView:UIViewController) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        presentationController.canOverlapSourceViewRect = true
        presentView.present(controller, animated: true)
    }
    
    
    static func showFilePreviewView(_ urls:[String],_ vc:UIViewController?){
        var previewUrls = [URL]()
        for url in urls {
            previewUrls.append(url.toFileUrl)
        }
        
        if previewUrls.count > 0 {
            var finalvc = vc
            if finalvc == nil {
                finalvc = UIApplication.topViewController()
            }
            let storyboard = UIStoryboard(name: "Common", bundle: nil)
            let pushView = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
            pushView.previewUrls = previewUrls
            let rootView = UINavigationController(rootViewController: pushView)
            finalvc?.present(rootView, animated: true, completion: nil)
        }
    }
    
    
}
