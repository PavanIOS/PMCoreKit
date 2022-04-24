//
//  UIView_Extension.swift
//  BMS
//
//  Created by Sekhar on 16/12/18.
//  Copyright © 2018 Sekhar n. All rights reserved.
//

import Foundation
import UIKit



//MARK: - UIView Extension
public extension UIView {

    
    enum BorderSide {
           case top(thickness: CGFloat = 1.0, color: UIColor = UIColor.lightGray)
           case bottom(thickness: CGFloat = 1.0, color: UIColor = UIColor.lightGray)
           case right(thickness: CGFloat = 1.0, color: UIColor = UIColor.lightGray)
           case left(thickness: CGFloat = 1.0, color: UIColor = UIColor.lightGray)
       }
    
    
    
    func addBorder(on sides: [BorderSide]) {
         for side in sides {
             let border = UIView(frame: .zero)
            border.accessibilityIdentifier = "border"
          //  border.backgroundColor = color
             border.translatesAutoresizingMaskIntoConstraints = false
             self.addSubview(border)
             
             switch side {
             case .top(let thickness, let color):
                 NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: thickness).isActive = true
                 border.backgroundColor = color
                 
             case .bottom(let thickness, let color):
                 NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: thickness).isActive = true
                 border.backgroundColor = color
                 
             case .left(let thickness, let color):
                 NSLayoutConstraint(item: border, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: thickness).isActive = true
                 border.backgroundColor = color
                 
             case .right(let thickness, let color):
                 NSLayoutConstraint(item: border, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
                 NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: thickness).isActive = true
                 border.backgroundColor = color
             }
         }
     }
    
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        if #available(iOS 11.0, *){
            var maskedConers = CACornerMask()
            if corners.contains(.topLeft) {
                maskedConers.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.topRight) {
                maskedConers.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.bottomLeft) {
                maskedConers.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight) {
                maskedConers.insert(.layerMaxXMaxYCorner)
            }
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = maskedConers
        }else{
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotateView(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
    
    enum UIViewFadeStyle {
        case bottom
        case top
        case left
        case right
        
        case vertical
        case horizontal
    }
    
    func fadeView(style: UIViewFadeStyle = .bottom, percentage: Double = 0.07) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        
        let startLocation = percentage
        let endLocation = 1 - percentage
        
        switch style {
        case .bottom:
            gradient.startPoint = CGPoint(x: 0.5, y: endLocation)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        case .top:
            gradient.startPoint = CGPoint(x: 0.5, y: startLocation)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, startLocation, endLocation, 1.0] as [NSNumber]
            
        case .left:
            gradient.startPoint = CGPoint(x: startLocation, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .right:
            gradient.startPoint = CGPoint(x: endLocation, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, startLocation, endLocation, 1.0] as [NSNumber]
        }
        
        layer.mask = gradient
    }
    
    fileprivate var hairlineImageView: UIImageView? {
        return hairlineImageView(in: self)
    }
    
    fileprivate func hairlineImageView(in view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
            return imageView
        }
        for subview in view.subviews {
            if let imageView = self.hairlineImageView(in: subview) { return imageView }
        }
        return nil
    }
    
    
    func setupGlobalGradient(startColor:UIColor,endColor:UIColor,gradientHorizontal:Bool){
        
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func gradient(_ UIColor:[UIColor],_ radius:CGFloat=0,_ horizontal:Bool=false){
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.layer.bounds
        var cgUIColor = [CGColor]()
        for color in UIColor {
            cgUIColor.append(color.cgColor)
        }
        gradientLayer.colors = cgUIColor
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = horizontal ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 1)
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
//    func setupButtonGradient(_ UIColor:[UIColor],_ horizontal:Bool){
//        gradient?.removeFromSuperlayer()
//        gradient = CAGradientLayer()
//        guard let gradient = gradient else { return }
//        var cgUIColor = [CGColor]()
//        for color in UIColor {
//            cgUIColor.append(color.cgColor)
//        }
//        gradient.frame = self.layer.bounds
//        gradient.colors = cgUIColor
//        gradient.startPoint = CGPoint(x: 0, y: 0)
//        gradient.endPoint = horizontal ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 1)
//        gradient.cornerRadius = self.cornerRadius
//        self.layer.insertSublayer(gradient, below: self.imageView?.layer)
//    }
    
}




//MARK: - UITableView Extension
extension UITableView {
    
    func setEmptyMessage(_ message: String,_ color:UIColor) {
        let messageLabel = UILabel(frame: CGRect(x: 15, y: 100, width: self.bounds.size.width-30, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore(_ seperator:UITableViewCell.SeparatorStyle) {
        self.backgroundView = nil
        self.separatorStyle = seperator
    }
    
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    enum scrollsTo {
        case top,bottom
    }
    
    
    func scrollToTop() {
        let numberOfSections = self.numberOfSections
        let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
        if numberOfRows > 0 {
            let topRow = IndexPath(row: 0,
                                   section: 0)
            self.scrollToRow(at: topRow,
                             at: .top,
                             animated: true)
        }
    }
    
    
    func reloadWithAnimation(duration:Double = 0.3){
        
        UIView.performWithoutAnimation {
            self.reloadData()
        }
    }
    
    public func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
        
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
        
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
    
    // To Check Valid IndexPath/Row
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}


//MARK: - UICollectionView Extension
public extension UICollectionView {
    // To Check Valid IndexPath/Item
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }
}


//MARK: - UIStackView public extension
public extension UIStackView {
    func addBackground(color: UIColor) {
        if let prevColor = self.subviews.filter({$0.accessibilityIdentifier == "color"}).first {
            prevColor.backgroundColor = color
        }else{
            let subView = UIView(frame: bounds)
            subView.backgroundColor = color
            subView.accessibilityIdentifier = "color"
            subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            insertSubview(subView, at: 0)
        }
    }
    
    func cornerRadius(radius:CGFloat = 0) {
        let subviews1 = subviews.filter({$0.isHidden == false})
        if let first = subviews1.first {
            first.roundCorners(corners: [.topLeft,.topRight], radius: radius)
        }
        if let last = subviews1.last {
            last.roundCorners(corners: [.bottomLeft,.bottomRight], radius: radius)
        }
    }
    
    func addBorder(color: UIColor, backgroundColor: UIColor, thickness: CGFloat) {
        let insetView = UIView(frame: bounds)
        insetView.backgroundColor = backgroundColor
        insetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(insetView, at: 0)
        
        let borderBounds = CGRect(
            x: thickness,
            y: thickness,
            width: frame.size.width - thickness * 2,
            height: frame.size.height - thickness * 2)
        
        let borderView = UIView(frame: borderBounds)
        borderView.backgroundColor = color
        borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(borderView, at: 0)
    }
}


//MARK: - UIScreen public extension
public extension UIScreen {
    public class var Orientation: UIInterfaceOrientation {
        get {
            return UIApplication.shared.statusBarOrientation
        }
    }
    public class var ScreenWidth: CGFloat {
        get {
            if Orientation.isPortrait {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }
    public class var ScreenHeight: CGFloat {
        get {
            if Orientation.isPortrait {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
    }
}





//MARK: - UIApplication Extension
public extension UIApplication {
    
    public class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
//        if let slide = viewController as? SlideMenuController {
//            return topViewController(slide.mainViewController)
//        }
        return viewController
    }
}


//MARK: - UINavigationBar public extension
public extension UINavigationBar {
    func hideBorderLine() {
        self.hairlineImageView?.isHidden = true
    }
    
    func showBorderLine() {
        self.hairlineImageView?.isHidden = false
    }
}


//MARK: - UIToolbar public extension
public extension UIToolbar {
    func hideBottomHairline() {
        self.hairlineImageView?.isHidden = true
    }
    
    func showBottomHairline() {
        self.hairlineImageView?.isHidden = false
    }
}


//MARK: - UISegmentedControl Extension
public extension UISegmentedControl {
    enum SegmentAlignment {
        case Left
        case Right
        case Default
    }
    
    func justifyItems(segments:[Int],alignment:SegmentAlignment = .Default, margin:CGFloat = 15) {
        let fontAttributes = titleTextAttributes(for: .normal)
        let totalSegments = numberOfSegments - 1
        let controlWidth = frame.size.width
        let segmentWidth = controlWidth / CGFloat(numberOfSegments)
        for segment in 0...totalSegments {
            if segments.contains(segment) || segments.count == 0{
                let title = titleForSegment(at: segment)
                setWidth(segmentWidth, forSegmentAt: segment)
                if let t = title {
                    let titleSize = t.size(withAttributes: fontAttributes)
                    let offset = (segmentWidth - titleSize.width) / 2 - margin
                    if alignment == .Left {
                        self.setContentOffset(CGSize(width: -offset, height: 0), forSegmentAt: segment)
                    }else if alignment == .Right {
                        self.setContentOffset(CGSize(width: offset, height: 0), forSegmentAt: segment)
                    }else{
                        // Default
                    }
                }
            }
        }
    }
}




public extension UISearchBar {
    func changeSearchBarColor(color : UIColor) {
        
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = color
            if color.isLight {
                textfield.tintColor = .black
            }else{
                textfield.tintColor = .white
            }
        }
    }
}


public extension UINavigationController {
    
    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
    
    func popPushToVC(ofKind kind: AnyClass, pushController: UIViewController) {
        if containsViewController(ofKind: kind) {
            for controller in self.viewControllers {
                if controller.isKind(of: kind) {
                    popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            pushViewController(pushController, animated: true)
        }
    }
    
}



// MARK: Add and Remove Child View Controllers
public extension UIViewController {
    
    func getCustomBarButton(icon:UIImage) -> CustomButton {
        let size : CGFloat = 50.0
        let customBarButton = CustomButton(type: .custom)
        customBarButton.buttonImage = icon
        customBarButton.imageView?.contentMode = .scaleAspectFit
        customBarButton.frame = CGRect(x: 0, y: 0, width: size, height: size)
        if #available(iOS 11.0, *)
        {
            customBarButton.widthAnchor.constraint(equalToConstant: size).isActive = true
            customBarButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        }else
        {
            var frame = customBarButton.frame
            frame.size.width = size
            frame.size.height = size
            customBarButton.frame = frame
        }
        return customBarButton
    }
    
    func hideNavBarSeperator() {
        self.navigationController?.navigationBar.shadowImage = ImageNames.emptyImage
        self.navigationController?.navigationBar.setBackgroundImage(ImageNames.emptyImage, for: UIBarMetrics.default)
    }
    
    func showNavBarSeperator() {
        let img = UIImage.pixelImageWithColor(color: UIColor.lightGray.withAlphaComponent(0.8))//Use Any Color
        self.navigationController?.navigationBar.shadowImage = img
    }
    
    func addChildViewController(_ controller:UIViewController,_ toView:UIView,_ frame:CGRect? = nil){
        
        if !isChildViewExisted() {
            
            controller.view.frame = frame ?? toView.bounds
            controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            controller.view.accessibilityIdentifier = "Child"
            controller.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.33, animations: {
                controller.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.addChild(controller)
                self.view.addSubview(controller.view)
                controller.didMove(toParent: self)
            })
        }
    }
    
    func addChildViewControllerToWindow(controller:UIViewController){
        let window = UIApplication.shared.keyWindow! as UIWindow
        
        controller.view.frame = window.bounds
        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        controller.view.accessibilityIdentifier = "Child"
        controller.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.33, animations: {
            controller.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            window.rootViewController?.addChild(controller)
            window.rootViewController?.view.addSubview(controller.view)
            controller.didMove(toParent: self)
        })
    }
    
    func removeCurrentViewController(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
    }
    
    func removeChildViewController(){
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
    
    func isChildViewExisted() -> Bool{
        var isExisted = false
        if self.children.count > 0 {
            for view in self.view.subviews {
                if view.accessibilityIdentifier == "Child" {
                    isExisted = true
                }
            }
        }
        return isExisted
    }
}






//MARK: - Different corners
public extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
             path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }

        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }

        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }

        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        path.closeSubpath()
        cgPath = path
    }
}


public extension UIView {
    func roundCorners(_ topLeft: CGFloat = 0,_ topRight: CGFloat = 0,_ bottomLeft: CGFloat = 0,_ bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
          let topLeftRadius = CGSize(width: topLeft, height: topLeft)
          let topRightRadius = CGSize(width: topRight, height: topRight)
          let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
          let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
          let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
          let shape = CAShapeLayer()
          shape.path = maskPath.cgPath
          layer.mask = shape
      }
    
    
    func setBorderLayer(_ width:CGFloat,_ color:UIColor){
        
        let borderLayer = CAShapeLayer()
        if let shapeLayer = self.layer.mask as? CAShapeLayer {
            borderLayer.path = shapeLayer.path
        }
       // borderLayer.path = (self.layer.mask! as! CAShapeLayer).path! // Reuse the Bezier path
        borderLayer.strokeColor = color.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = width
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
