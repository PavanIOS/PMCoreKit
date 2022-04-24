

import Foundation
import UIKit


public class CustomStackView : UIStackView {
    
    @IBInspectable var inset:Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomBorder: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var rightBorder: CGFloat = 0 {
        didSet {
           
            setNeedsLayout()
        }
    }
    
    @IBInspectable var leftBorder: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var topBorder: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    
    var padding : UIEdgeInsets? = nil {
           didSet {
               self.layoutMargins = padding ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.isLayoutMarginsRelativeArrangement = true
           }
       }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if topBorder > 0 || bottomBorder > 0 || rightBorder > 0 || leftBorder > 0 {
        self.setBorders(top: topBorder, bottom: bottomBorder, left: leftBorder, right: rightBorder, color: borderColor, inset: inset)
        }
    }
   
}


public extension CustomStackView {
    
    func removeAllSubViews(){
        let subviews = self.arrangedSubviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func insertLabel(_ text:String,_ font:UIFont,_ color:UIColor) {
        let lbl1 = CustomLabel()
        lbl1.text = text
        lbl1.font = font
        lbl1.textColor = color
        lbl1.numberOfLines = 0
        
        self.addArrangedSubview(lbl1)
    }
    
    func insertTextView(_ textView:CustomTextView, text:String,_ mandatory:Bool,_ axis:NSLayoutConstraint.Axis = .vertical) {
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 5
        if axis == .horizontal {
        stack1.distribution = .fillEqually
        }
        
        let lbl1 = CustomLabel()
        lbl1.text = text + " : "
        lbl1.font = CustomFonts.getRegularFont()
        if mandatory {
           // lbl1.setMandatoryIcon(ImageNames.mandatory)
        }
        textView.placeholderLabel.text = ""
        textView.setCommonTextView(text)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        stack1.addArrangedSubview(lbl1)
        stack1.addArrangedSubview(textView)
        
        self.addArrangedSubview(stack1)
    }
    
    func insertTextField(_ textField:CustomTextField, text:String,_ mandatory:Bool,_ axis:NSLayoutConstraint.Axis){
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 5
        if axis == .horizontal {
        stack1.distribution = .fillEqually
        }
        
        let lbl1 = CustomLabel()
        lbl1.text = text + " : "
        lbl1.font = CustomFonts.getRegularFont(.NORMAL)
        lbl1.numberOfLines = 0
        if mandatory {
            
           //  lbl1.setMandatoryIcon(ImageNames.mandatory)
        }
        
        textField.setCommonTextField(text)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.isMandatory = mandatory
       // textField.textInputDelegate = self
        
        stack1.addArrangedSubview(lbl1)
        stack1.addArrangedSubview(textField)
        self.addArrangedSubview(stack1)
    }
    
    
    func setupDetailValue(_ lText:String,_ rText:String,_ axis:NSLayoutConstraint.Axis) {
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 5
        stack1.distribution = .fillEqually
        
        let lbl1 = CustomLabel()
        lbl1.text = lText
        lbl1.font = CustomFonts.getRegularFont(.NORMAL)
        lbl1.numberOfLines = 0
        
        let lbl2 = CustomLabel()
        lbl2.text = rText
        lbl2.font = CustomFonts.getMediumFont(.MEDIUM)
        lbl2.numberOfLines = 0
        
        if lText != "" {
            stack1.addArrangedSubview(lbl1)
        }
        if rText != "" {
            stack1.addArrangedSubview(lbl2)
        }
        self.addArrangedSubview(stack1)
    }
    
    
    func insertLabelAndButton(_ lbl1:CustomLabel,_ btn:CustomButton,_ axis:NSLayoutConstraint.Axis,_ width:CGFloat = 35,_ height:CGFloat=35) {
        
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 5
        stack1.distribution = .fill
        
        if lbl1.font == nil {
            lbl1.font = CustomFonts.getRegularFont(.NORMAL)
        }
       
        lbl1.numberOfLines = 0
        
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: width).isActive = true
        btn.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        stack1.addArrangedSubview(lbl1)
        stack1.addArrangedSubview(btn)
        self.addArrangedSubview(stack1)
    }
    
    func setupLabelAndSwitch(_  lText:String,_ mSwitch:CustomSwitch,_ axis:NSLayoutConstraint.Axis) {
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 5
        stack1.distribution = .fill
        
        let lbl1 = CustomLabel()
        lbl1.text = lText
        lbl1.font = CustomFonts.getRegularFont(.NORMAL)
        lbl1.numberOfLines = 0
        
        mSwitch.translatesAutoresizingMaskIntoConstraints = false
        mSwitch.heightAnchor.constraint(equalToConstant: 35).isActive = true
        mSwitch.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        stack1.addArrangedSubview(lbl1)
        stack1.addArrangedSubview(mSwitch)
        
        stack1.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        
        self.addArrangedSubview(stack1)
    }
    
    func setupLabelAndImage(_ lbl1:CustomLabel, _ fileImg:UIImage,_ axis:NSLayoutConstraint.Axis) {
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 10
        stack1.alignment = .center
        stack1.distribution = .fill
        lbl1.font = CustomFonts.getRegularFont(.NORMAL)
        lbl1.numberOfLines = 0
        
        let img = CustomImageView()
        img.image = fileImg
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 35).isActive = true
        img.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        stack1.addArrangedSubview(img)
        stack1.addArrangedSubview(lbl1)
        self.addArrangedSubview(stack1)
    }
    
    
    
    func setupTextFieldAndButton(_ textField:CustomTextField,_ btn:CustomButton,_ text:String,_ axis:NSLayoutConstraint.Axis) {
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 10
        stack1.distribution = .fill
        
        textField.setCommonTextField(text)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.isMandatory = false
        textField.withImage(.Right, ImageNames.expand, UIColor.gray)
        
       // textField.textInputDelegate = self
        
        btn.addRightImage(UIImage.system(name: .upload_icloud), .zero, .gray)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        stack1.addArrangedSubview(textField)
        stack1.addArrangedSubview(btn)
        self.addArrangedSubview(stack1)
    }
    
    
    
    func setSeprator(){
        let seprator = UIView()
        seprator.translatesAutoresizingMaskIntoConstraints = false
        seprator.heightAnchor.constraint(equalToConstant: 5).isActive = true
        seprator.backgroundColor = .darkGray
        self.addArrangedSubview(seprator)
    }
    
    func addSpacer(){
        let spacer = UIView()
        spacer.backgroundColor = .clear
        self.addArrangedSubview(spacer)
    }
    
    
    func insertButton(_ button:CustomButton,_ height:CGFloat) {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.addArrangedSubview(button)
    }
    
    
    func insertRadioButtons(_  lText:String,_ btns:[CustomButton],_ axis:NSLayoutConstraint.Axis) {
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 5
        stack1.distribution = .fill
        
        let lbl1 = CustomLabel()
        lbl1.text = lText
        lbl1.font = CustomFonts.getRegularFont(.NORMAL)
        lbl1.numberOfLines = 0
        
        let vStack = CustomStackView()
        vStack.axis = .horizontal
        vStack.spacing = 5
        vStack.distribution = .fillEqually
        
        for btn in btns {
            vStack.addArrangedSubview(btn)
        }
        
        stack1.addArrangedSubview(lbl1)
        stack1.addArrangedSubview(vStack)
        
        stack1.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        
        self.addArrangedSubview(stack1)
    }
    
    
    func insertTextAndButton(_ lText:String, _ button:CustomButton,_ axis:NSLayoutConstraint.Axis) {
        let stack1 = CustomStackView()
        stack1.axis = axis
        stack1.spacing = 10
        stack1.alignment = .center
        stack1.distribution = .fill
        
        
        let lbl1 = CustomLabel()
        lbl1.text = lText
        lbl1.font = CustomFonts.getRegularFont(.NORMAL)
        lbl1.numberOfLines = 0
      
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        stack1.addArrangedSubview(lbl1)
        stack1.addArrangedSubview(button)
        
        self.addArrangedSubview(stack1)
    }
    
    func insertDirectLabel(_ lbl:CustomLabel) {
        lbl.numberOfLines = 0
        
        self.addArrangedSubview(lbl)
    }
    
}

