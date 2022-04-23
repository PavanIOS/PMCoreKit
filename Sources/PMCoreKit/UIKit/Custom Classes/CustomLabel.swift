

import UIKit

public enum SMIconHorizontalPosition {
    case left
    case right
}

public enum SMIconVerticalPosition {
    case top
    case center
    case bottom
}

public typealias SMIconPosition = (horizontal: SMIconHorizontalPosition, vertical: SMIconVerticalPosition)


public class CustomLabel: UILabel {
    var section = 0
    var row = 0
    
    
    var adjustFontsize : Bool = true {
        didSet {
            self.sizeToFit()
            self.adjustsFontSizeToFitWidth = adjustFontsize
            
        }
    }
    
    public var icon: UIImage? {
        didSet {
            if icon == nil {
                iconView?.removeFromSuperview()
            }
            setNeedsDisplay()
        }
    }
    fileprivate var iconView: UIImageView?
    public var iconPosition: SMIconPosition = ( .left, .top )
    public var iconPadding: CGFloat = 0
    
    
    var borderWidth : CGFloat = 1 {
        didSet {
            self.setupBorderWidth(width: borderWidth)
        }
    }
    var borderColor : UIColor = Colors.lightGray {
        didSet {
            self.setupBorderColor(color: borderColor)
        }
    }
    
    
    open override func awakeFromNib() {
        
    }
    
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: textString.count))
            self.attributedText = attributedString
        }
    }
    
    func updatebadgeCount(value:Int){
        let fontSize = self.font.pointSize
        self.clipsToBounds = true
        self.layer.cornerRadius = fontSize * CGFloat(0.6) // fontSize * 1.2 / 2
        self.backgroundColor = UIColor.red
        self.textColor = UIColor.white
        if value == 1 {
            self.text = "  \(value)  " // note spaces before and after text
        }else{
            self.text = " \(value) " 
        }
        
        if value > 0 {
            self.isHidden = false
        }else{
            self.isHidden = true
        }
    }
    
    private func setupBorderWidth(width:CGFloat){
        self.layer.borderWidth = width
    }
    
    private func setupBorderColor(color:UIColor){
        self.layer.borderColor = color.cgColor
    }
    
    
    
    func setMandatoryIcon() {
        if let text = self.text {
            let color = self.textColor ?? .black
            let font = self.font ?? CustomFonts.getRegularFont(.NORMAL)
            self.attributedText = NSMutableAttributedString().text(text, color,font).icon(image: ImageNames.mandatory, width: 8, height: 8)
        }
    }
}

public extension CustomLabel {
    
    
    open override func drawText(in rect: CGRect) {
        guard let text = self.text as NSString? else { return }
        guard let icon = icon else {
            super.drawText(in: rect)
            return
        }
        
        iconView?.removeFromSuperview()
        iconView = UIImageView(image: icon)
        iconView?.frame.size = CGSize(width: 8, height: 8)
        
        var newRect = CGRect.zero
        let size = text.boundingRect(with: CGSize(width: frame.width - icon.size.width - iconPadding, height: CGFloat.greatestFiniteMagnitude),
                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                     attributes: [ NSAttributedString.Key.font : font ?? 17 ],
                                     context: nil).size
        
        guard let iconView = iconView else { return }
        let iconYPosition = (frame.height - iconView.frame.height) / 2
        let height = frame.height
        
        if iconPosition.horizontal == .left {
            if textAlignment == .left {
                iconView.frame = iconView.frame.offsetBy(dx: 0, dy: iconYPosition)
                newRect = CGRect(x: iconView.frame.width + iconPadding, y: 0, width: frame.width - (iconView.frame.width + iconPadding), height: height)
            } else if textAlignment == .right {
                iconView.frame = iconView.frame.offsetBy(dx: frame.width - size.width - iconView.frame.width - iconPadding, dy: iconYPosition)
                newRect = CGRect(x: frame.width - size.width - iconPadding, y: 0, width: size.width + iconPadding, height: height)
            } else if textAlignment == .center {
                iconView.frame = iconView.frame.offsetBy(dx: (frame.width - size.width) / 2 - iconPadding - iconView.frame.width, dy: iconYPosition)
                newRect = CGRect(x: (frame.width - size.width) / 2, y: 0, width: size.width + iconPadding, height: height)
            }
        } else if iconPosition.horizontal == .right {
            if textAlignment == .left {
                iconView.frame = iconView.frame.offsetBy(dx: size.width + iconPadding, dy: iconYPosition)
                newRect = CGRect(x: 0, y: 0, width: size.width, height: height)
            } else if textAlignment == .right {
                iconView.frame = iconView.frame.offsetBy(dx: frame.width - iconView.frame.width, dy: iconYPosition)
                newRect = CGRect(x: frame.width - size.width - iconView.frame.width - iconPadding, y: 0, width: size.width, height: height)
            } else if textAlignment == .center {
                iconView.frame = iconView.frame.offsetBy(dx: frame.width / 2 + size.width / 2 + iconPadding, dy: iconYPosition)
                newRect = CGRect(x: (frame.width - size.width) / 2, y: 0, width: size.width, height: height)
            }
        }
        
        switch iconPosition.vertical {
        case .top:
            iconView.frame.origin.y = (frame.height - size.height) / 2
            
        case .center:
            iconView.frame.origin.y = (frame.height - iconView.frame.height) / 2
            
        case .bottom:
            iconView.frame.origin.y = frame.height - (frame.height - size.height) / 2 - iconView.frame.size.height
        }
        addSubview(iconView)
        super.drawText(in: newRect)
    }
    
    public func setMandatoryIcon(_ image:UIImage,_ hor_position:SMIconHorizontalPosition = .left,_ ver_position:SMIconVerticalPosition = .top){
        self.icon = image
        self.iconPadding = 2
        self.numberOfLines = 0
        self.iconPosition = ( hor_position, ver_position )
    }
    
    
}


@IBDesignable public class PaddingLabel: CustomLabel {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}



public class BadgeLabel : CustomLabel {
    
    
    func updateBadgeValue(count:Int) {
        if count > 0 {
            let fontSize: CGFloat = 16
            self.font = UIFont.systemFont(ofSize: fontSize)
            self.textAlignment = .center
            self.textColor = UIColor.white
            self.backgroundColor = UIColor.red
            
            // Add count to label and size to fit
            self.text = "\(count)"
            self.sizeToFit()
            
            // Adjust frame to be square for single digits or elliptical for numbers > 9
            var frame: CGRect = self.frame
            frame.size.height += CGFloat(Int(0.4 * fontSize))
            frame.size.width = (count <= 9) ? frame.size.height : frame.size.width + CGFloat(Int(fontSize))
            self.frame = frame
            
            // Set radius and clip to bounds
            self.layer.cornerRadius = frame.size.height / 2.0
            self.clipsToBounds = true
            
        }else{
            self.isHidden = true
        }
    }
    
}
