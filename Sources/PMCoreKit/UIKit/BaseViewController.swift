//
//  BaseViewController.swift
//  Regent
//
//  Created by sn99 on 19/01/21.
//  Copyright © 2021 sn99. All rights reserved.
//

import UIKit
import Foundation
import QuickLook




// Sprt Example =   sorted(by: { $0.id.intValue > $1.id.intValue })




public class BaseViewController: UIViewController {
    
//    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//    var sceneDelegate : SceneDelegate? = nil
    
    var defaults = UserDefaults.standard
    let newLine = "\n"
    
    
   
    
  
    
    var largeTitles : Bool = false {
        didSet{
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.prefersLargeTitles = largeTitles
            }
        }
    }
    
    var largeTitleMode : UINavigationItem.LargeTitleDisplayMode = .never {
        didSet{
            if #available(iOS 11.0, *) {
                self.navigationItem.largeTitleDisplayMode = largeTitleMode
            }
        }
    }
    
    
    
    
    var previewUrls = [URL]()
    let child = "Child"
    var initiate = true
    
    
    var pullToRefresh = UIRefreshControl() // Pull To Refresh
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initiate = false
        self.initialSetup()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppear()
        hideKeyboard()
        viewControllerInitiated(initiate)
    }
    
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideKeyboard()
        viewWillDisappear()
        if self.isMovingFromParent {
            viewControllerPopped()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
           // self.sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        }
        updateSafeAreaPadding()
    }
    
    func updateSafeAreaPadding(){
        topPadding = view.safeAreaInsets.top
        bottomPadding = view.safeAreaInsets.bottom
        
        if bottomPadding > 0 {
            bottomPadding = bottomPadding/2
        }
    }
    
    func initialSetup(){
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        setupLayouts()
        setupView()
        setupBarButtons()
    }
    
    open func viewWillAppear(){
        
    }
    
    open func viewWillDisappear(){
        
    }
    
    open func setupView() {
        
    }
    
    open func setupLayouts() {
        
    }
    
    func setupBarButtons(){
        
    }
    
    func viewControllerPopped(){
        
    }
    
    func viewControllerInitiated(_ initiate:Bool){
        
    }
    
    
    //MARK : Private Methods
   
    
    func transparentNavigatoionBar(_ transparent:Bool = false,_ titleColor:UIColor = .black){
        self.navigationController?.navigationBar.isTranslucent = true
        if transparent {
            self.navigationController?.navigationBar.setBackgroundImage(ImageNames.emptyImage, for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = ImageNames.emptyImage
            let titleAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
            self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        }else{
            // self.navigationController?.navigationBar.showBorderLine()
        }
        
    }
    
    func changeNavigatonBarColor(_ bgColor:UIColor,_ textColor:UIColor){
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.changeForegroundColor(textColor)
    }
    
    func changeForegroundColor(_ color:UIColor)
    {
        self.navigationController?.navigationBar.tintColor = color
        let titleAttributes = [NSAttributedString.Key.foregroundColor: color]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }
    
    func resetNavigationBar(){
        navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.titleTextAttributes = nil
    }
    
    
    func makePhoneCall(number:String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            CommonAlertView.shared.showAlert("Unable to call")
        }
    }
    
}



//MARK: Customized Functions
public extension BaseViewController {
    
    func customizeNavigationbar(){
        self.navigationItem.leftItemsSupplementBackButton = true // To add more back buttons with default back button
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.groupTableViewBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.compactAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    
    
    func addTapGesture(senderView : UIView? = nil){
        var tapView = senderView
        if(tapView == nil){
            tapView = self.view
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        tapView?.tag = senderView?.tag ?? 100
        tapView?.addGestureRecognizer(tap)
        tapView?.isUserInteractionEnabled = true
    }
    
    @objc public func handleTap(_ sender: UITapGestureRecognizer) {
        self.hideKeyboard()
    }
    
    public func setCustomBackButton(_ image:UIImage,_ text:String,_ color:UIColor){
        let button = UIButton(type: .system)
        let backArrow = image
        button.setImage(backArrow, for: .normal)
        button.setTitle(text, for: .normal)
        button.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
        button.sizeToFit()
        button.tintColor = color
        
        let leftBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc public func backButtonClicked() {
        
    }
    
}

extension BaseViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}





extension BaseViewController : QLPreviewControllerDataSource {
    static var previewUrls = [URL]()
    
    func loadPreview(urls:[String]){
        previewUrls.removeAll()
        for url in urls {
            if !url.isEmpty {
            previewUrls.append(url.toFileUrl)
            }
        }
        
        if previewUrls.count > 0 {
            let previewController = PreviewViewController()
            previewController.dataSource = self
            let rootView = UINavigationController(rootViewController: previewController)
            self.present(rootView, animated: true)
        }
        else {
            CommonAlertView.shared.showAlert("No file selected")
        }
        
    }
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewUrls.count
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let currentItem = previewUrls[index]
        return currentItem as QLPreviewItem
    }
}








public extension UIViewController {
    
    func hideBackButtonTitle(){
        self.setBackButtonTitle(text: "")
    }

    
     func setBackButtonTitle(text:String? = nil,color:UIColor? = nil){
        let backButton = UIBarButtonItem()
        if text != nil {
            backButton.title = text
        }
        if color != nil {
            backButton.tintColor = color
        }
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    func updateConstraintsImmediately() {
        self.view.layoutIfNeeded() // To update constraints immediately
    }
    
 
   
    
    public func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func hideNavigationbar(_ hide:Bool = true){
        self.navigationController?.navigationBar.isHidden = hide
    }
    
}
