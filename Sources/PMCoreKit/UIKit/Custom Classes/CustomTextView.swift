

import UIKit

@objc protocol CustomTextViewDelegate : AnyObject {
    
    @objc optional func textViewShouldBeginEditing(_ textView: CustomTextView) -> Bool
    @objc optional func textViewShouldEndEditing(_ textView: CustomTextView) -> Bool
    @objc optional func textViewDidBeginEditing(_ textView: CustomTextView)
    @objc optional func textViewDidEndEditing(_ textView: CustomTextView)
    @objc optional func textView(_ textView: CustomTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    @objc optional func textViewDidChange(_ textView: CustomTextView)
    @objc optional func textViewDidChangeSelection(_ textView: CustomTextView)
    @objc optional func textView(_ textView: CustomTextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    @objc optional func textView(_ textView: CustomTextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    @objc  optional func textView(_ textView: CustomTextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool
    @objc optional func textView(_ textView: CustomTextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool
}

public class CustomTextView: UITextView {
    
    var placeholderLabel = UILabel()
    
    
    
    var cornerRadius : CGFloat = 5 {
        didSet {
            self.setCornerRadius(cornerRadius)
        }
    }
   
    
    var enablePlaceHolder : Bool = false {
        didSet {
            self.placeholderLabel.isHidden = !enablePlaceHolder
        }
    }
    
    var adjustHeight : Bool = false {
        didSet {
            self.isScrollEnabled = !adjustHeight // Disable this to adjust tableview row auto height
        }
    }
    
    var placeHolder : String = "" {
        didSet {
            self.updatePlaceHolderText(placeHolderText: placeHolder)
        }
    }
    
   
    
    
    weak var textInputDelegate : CustomTextViewDelegate?
    
    var section = 0
    var row = 0
    var maxLength: Int = 0
    var isMandatory = true
    
    
    var leftPadding : CGFloat = 10
    
    
    public override var bounds: CGRect {
        didSet {
            placeholderLabel.frame = CGRect(x: leftPadding, y: (self.font?.pointSize ?? 15) / 2 - 5, width: self.frame.width, height: 30)
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.initSetup()
    }
    
    
     func initSetup(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter text"
        placeholderLabel.font = self.font // UIFont.italicSystemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame = CGRect(x: leftPadding, y: (self.font?.pointSize ?? 15) / 2 - 5, width: self.frame.width, height: 30)
        self.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty
        self.delegate = self
        
        if self.isEditable && self.text.isEmpty {
            placeholderLabel.isHidden = false
        }else{
            placeholderLabel.isHidden = true
        }
    }
    
    
     func updatePlaceHolderText(placeHolderText:String){
        placeholderLabel.text = placeHolderText
    }
    
     func hideAndShowPlaceHolder(){
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
     func setupBorders(_ color:UIColor = UIColor.lightGray,_ width:CGFloat=1.0){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    
    var isTextTruncated: Bool {
        var isTruncating = false
        
        // The `truncatedGlyphRange(...) method will tell us if text has been truncated
        // based on the line break mode of the text container
        layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: Int.max)) { _, _, _, glyphRange, stop in
            let truncatedRange = self.layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: glyphRange.lowerBound)
            if truncatedRange.location != NSNotFound {
                isTruncating = true
                stop.pointee = true
            }
        }
        
        // It's possible that the text is truncated not because of the line break mode,
        // but because the text is outside the drawable bounds
        if isTruncating == false {
            let glyphRange = layoutManager.glyphRange(for: textContainer)
            let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            
            isTruncating = characterRange.upperBound < text.utf16.count
        }
        
        return isTruncating
    }
}

 extension CustomTextView : UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        self.hideAndShowPlaceHolder()
        textInputDelegate?.textViewDidChange?(textView as! CustomTextView)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        textInputDelegate?.textViewDidEndEditing?(textView as! CustomTextView)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        textInputDelegate?.textViewDidBeginEditing?(textView as! CustomTextView)
    }
    
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let finalText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if maxLength > 0, maxLength < finalText.utf8.count {
            return false
        }
        return true
    }
}


public extension CustomTextView {
    func setCommonTextView(_ placeHolder:String){
        self.font = CustomFonts.getRegularFont(.NORMAL)
        self.initSetup()
        self.cornerRadius = 5
        self.setBorder(1.0, UIColor.separator)
        self.placeHolder = placeHolder
    }
    
    
    func setText(text:String) {
        self.text = text
        self.hideAndShowPlaceHolder()
    }
}
