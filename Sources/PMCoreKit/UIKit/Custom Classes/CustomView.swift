

import UIKit


public class CustomView: UIView {
    
    var section = 0
    var row = 0
    
    var cornerRadius : CGFloat = 0 {
        didSet {
            self.setCornerRadius(cornerRadius)
        }
    }
    
    var padding : UIEdgeInsets? = nil {
        didSet {
            self.layoutMargins = padding ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}


extension UIView {
    
    func setCornerRadius(_ radius:CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setBorder(_ width:CGFloat,_ color:UIColor){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    public func removeBorders(){
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0.0
    }
    
    func setCircle(){
        self.setCornerRadius(self.frame.height/2)
    }
    
    func setupGradient(_ startColor:UIColor,_ endColor:UIColor,_ horizontal:Bool){
        let layerAccessibilityHint = "Gradient"
        self.layer.sublayers?.removeAll(where: {$0.accessibilityHint == layerAccessibilityHint})
        
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.accessibilityHint = layerAccessibilityHint
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func dropShadow() {
       // shadow
       self.layer.shadowColor = UIColor.black.cgColor
       self.layer.shadowOffset = CGSize(width: 3, height: 3)
       self.layer.shadowOpacity = 0.7
       self.layer.shadowRadius = 4.0
   }
    
}

extension UIView {
    // In order to create computed properties for extensions, we need a key to
      // store and access the stored property
      fileprivate struct AssociatedObjectKeys {
          static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
      }
      
      fileprivate typealias Action = (() -> Void)?
      
      // Set our computed property type to a closure
      fileprivate var tapGestureRecognizerAction: Action? {
          set {
              if let newValue = newValue {
                  // Computed properties get stored as associated objects
                  objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
              }
          }
          get {
              let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
              return tapGestureRecognizerActionInstance
          }
      }
      
      // This is the meat of the sauce, here we create the tap gesture recognizer and
      // store the closure the user passed to us in the associated object we declared above
      public func tapGesture(action: (() -> Void)?) {
          self.isUserInteractionEnabled = true
          self.tapGestureRecognizerAction = action
          let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
          self.addGestureRecognizer(tapGestureRecognizer)
      }
      
      // Every time the user taps on the UIImageView, this function gets called,
      // which triggers the closure we stored
      @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
          if let action = self.tapGestureRecognizerAction {
              action?()
          } else {
              print("no action")
          }
      }
    
    public func longTapGesture(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(sender:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleLongGesture(sender: UILongPressGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            if sender.state == .ended {
                action?()
            }
        } else {
            print("no action")
        }
    }
}


extension UIView {
    private static let layerNameTopBorder = "topBorder"
    private static let layerNameBottomBorder = "bottomBorder"
    private static let layerNameLeftBorder = "leftBorder"
    private static let layerNameRightBorder = "rightBorder"
    
     func setBorders(top topWidth: CGFloat, bottom bottomWidth: CGFloat, left leftWidth: CGFloat, right rightWidth: CGFloat, color: UIColor,inset:Bool = true) {
        var topBorderLayer:CALayer?
        var bottomBorderLayer:CALayer?
        var leftBorderLayer:CALayer?
        var rightBorderLayer:CALayer?
        if let sublayers = self.layer.sublayers {
        for borderLayer in sublayers {
            if borderLayer.name == UIView.layerNameTopBorder {
                topBorderLayer = borderLayer
            } else if borderLayer.name == UIView.layerNameRightBorder {
                rightBorderLayer = borderLayer
            } else if borderLayer.name == UIView.layerNameLeftBorder {
                leftBorderLayer = borderLayer
            } else if borderLayer.name == UIView.layerNameBottomBorder {
                bottomBorderLayer = borderLayer
            }
        }

        }

        // top border
        if topBorderLayer == nil {
            topBorderLayer = CALayer()
            topBorderLayer!.name = UIView.layerNameTopBorder
            self.layer.addSublayer(topBorderLayer!)
        }
        if inset {
            topBorderLayer!.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: topWidth)
        } else {
            topBorderLayer!.frame = CGRect(x: self.bounds.minX - leftWidth, y: self.bounds.minY - topWidth, width: self.bounds.width + leftWidth + rightWidth, height: topWidth)
        }
        topBorderLayer!.backgroundColor = color.cgColor


        // bottom border
        if bottomBorderLayer == nil {
            bottomBorderLayer = CALayer()
            bottomBorderLayer!.name = UIView.layerNameBottomBorder
            self.layer.addSublayer(bottomBorderLayer!)
        }
        if bottomWidth >= 0 {
            if inset {
                bottomBorderLayer!.frame = CGRect(x: self.bounds.minX, y:self.bounds.size.height - bottomWidth, width:self.bounds.size.width, height: bottomWidth)
            } else {
                bottomBorderLayer!.frame = CGRect(x: self.bounds.minX - leftWidth, y:self.bounds.size.height, width:self.bounds.size.width + leftWidth + rightWidth, height: bottomWidth)
            }
            bottomBorderLayer!.backgroundColor = color.cgColor
        }


        // left border
        if leftBorderLayer == nil {
            leftBorderLayer = CALayer()
            leftBorderLayer!.name = UIView.layerNameLeftBorder
            self.layer.addSublayer(leftBorderLayer!)
        }
        if inset {
            leftBorderLayer!.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: leftWidth, height: self.bounds.height)
        } else {
            leftBorderLayer!.frame = CGRect(x: self.bounds.minX - leftWidth, y: self.bounds.minY, width: leftWidth, height: self.bounds.height)
        }
        leftBorderLayer!.backgroundColor = color.cgColor


        // right border
        if rightBorderLayer == nil {
            rightBorderLayer = CALayer()
            rightBorderLayer!.name = UIView.layerNameRightBorder
            self.layer.addSublayer(rightBorderLayer!)
        }
        if inset {
            rightBorderLayer!.frame = CGRect(x: self.bounds.width - rightWidth, y: 0, width: rightWidth, height: self.bounds.height)
        } else {
            rightBorderLayer!.frame = CGRect(x: self.bounds.width, y: 0, width: rightWidth, height: self.bounds.height)
        }
        rightBorderLayer!.backgroundColor = color.cgColor
    }
    
}
