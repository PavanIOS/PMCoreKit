

import UIKit


enum ButtonType {
    case passwordShowHide
    case normal
}

@objc protocol CustomTextFieldDelegate : AnyObject {
    @objc optional  func didRightViewButton(sender:CustomButton,textField:CustomTextField)
    @objc optional  func textInputDidBeginEditing(textField: CustomTextField)
    @objc optional  func textInputDidEndEditing(textField: CustomTextField)
    @objc optional  func textInputDidChange(textField: CustomTextField)
    @objc optional  func textInput(textField: CustomTextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    @objc optional  func textInputShouldBeginEditing(textField: CustomTextField) -> Bool
    @objc optional  func textInputShouldEndEditing(textField: CustomTextField) -> Bool
    @objc optional  func textInputShouldReturn(textField: CustomTextField) -> Bool
    @objc optional  func textInputAutoComplete(textField: CustomTextField)
}


enum TextFieldType {
    case none
    case text
    case password
    case onlyLetters
    case onlyNumbers
    case phoneNumber
    case alphaNumeric
    case fullName
    case selection
    case dropdown
}



enum CustomTFTypes : Int {
//    typealias RawValue = Int
    
    case None = 0
}


class CustomTextField: UITextField {
    
    public enum DateType :String{
        case date = "dd-MMM-yyyy"
        case time = "hh:mm a"
        case dateTime = "dd-MMM-yyyy hh:mm a"
    }
    
    
    let defaultHeight : CGFloat = 31
    var isMandatory = true
    var maxLength: Int = 0
    var valueType: TextFieldType = TextFieldType.none
    var allowedCharInString = ""
    
    
    
    var cornerRadius : CGFloat = 5 {
        didSet {
            self.setCornerRadius(cornerRadius)
        }
    }
    
    var placeHolderFont : CGFloat = 20 {
        didSet {
            self.setupPlaceHolderFont(fontSize: placeHolderFont)
        }
    }
    var placeHolderColor : UIColor = Colors.lightGray {
        didSet {
            self.setupPlaceHolderColor(color: placeHolderColor)
        }
    }
    var leftPadding : CGFloat = 10 {
        didSet {
            self.setupLeftViewPadding(leftPadding)
        }
    }
    var rightPadding : CGFloat = 10 {
        didSet {
            self.setupRightViewPadding(rightPadding)
        }
    }
    
    var minimumDate : Date? = nil {
        didSet {
            datePicker.minimumDate = minimumDate
        }
    }
    var maximumDate : Date? = nil {
        didSet {
            datePicker.maximumDate = maximumDate
        }
    }
    
    
    var topPadding : CGFloat = 5
    
    
    let datePicker = UIDatePicker()
    var dateFormatType = DateType.date
    var selectedDate = Date()
    
    var picker = UIPickerView()
    var pickerDataSource = [OrderedDictionaryModel]()
    var selectedId = ""
    var selectedValue = ""
    var previousText = ""
    var isAutoComplete = false
    
    let border = CALayer()
    var bottomLayerWidth: CGFloat = 0.5
    
    var section = 0
    var row = 0
    
    
    var customTFType = CustomTFTypes.None
    
    weak var textInputDelegate : CustomTextFieldDelegate?
    
    
    override func awakeFromNib() {
        initSetup()
    }
    
    func initSetup(){
        self.keyboardType = UIKeyboardType.default
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.leftPadding = 10
        removeDropDown()
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: self.frame.size.height - bottomLayerWidth, width:  self.frame.size.width, height: self.frame.size.height)
    }
    
    
    //    func addBottomBorder(_ color:UIColor,_ height:CGFloat){
    //        let bottomLine = CALayer()
    //        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: height)
    //        bottomLine.backgroundColor = color.cgColor
    //        borderStyle = .none
    //        layer.addSublayer(bottomLine)
    //    }
    
    private func setupPlaceHolderFont(fontSize:CGFloat) {
        let placeHolder1 = NSMutableAttributedString(string:self.placeholder ?? "", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)])
        self.attributedPlaceholder = placeHolder1
    }
    
    private func setupPlaceHolderColor(color:UIColor){
        self.attributedPlaceholder =  NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func setupBottomBorder(_ width:CGFloat,_ color:UIColor) {
        self.bottomLayerWidth = width
        border.borderColor = color.cgColor
        border.borderWidth = bottomLayerWidth
        border.accessibilityHint = "BottomBorder"
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func removeBorderLayer(){
        for bottomLayer in self.layer.sublayers ?? [] {
            if let hint = bottomLayer.accessibilityHint, hint == "BottomBorder" {
                bottomLayer.removeFromSuperlayer()
            }
        }
    }
    
    
    private func setupLeftViewPadding(_ padding:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    private func setupRightViewPadding(_ padding:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setupRightViewButton(_ image:UIImage,_ color:UIColor,_ buttonType:ButtonType = .normal,_ enable:Bool = false){
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = color
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.isUserInteractionEnabled = enable
        self.rightView?.isUserInteractionEnabled = enable
        if(buttonType == ButtonType.passwordShowHide) {
            button.addTarget(self, action: #selector(self.showPasswordAction), for: .touchUpInside)
        }else{
            button.addTarget(self, action: #selector(self.rightButtonClicked), for: .touchUpInside)
        }
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @objc func rightButtonClicked(sender:CustomButton){
        self.textInputDelegate?.didRightViewButton?(sender: sender,textField: self)
    }
    
    @objc func showPasswordAction(sender:CustomButton){
        if self.isSecureTextEntry == true{
            self.isSecureTextEntry = false
            sender.setImage(ImageNames.showPassword, for: .normal)
        }else{
            self.isSecureTextEntry = true
            sender.setImage(ImageNames.hidePassword, for: .normal)
        }
    }

    
    
    func removeRightView(){
        self.rightView = nil
        self.tintColor = Colors.navBarColor
    }
    
    func removeDropDown(){
        self.removeRightView()
        self.inputView = nil
        self.tintColor = Colors.def_blue
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
    
    
    func setupDatePicker(_ format:DateType,_ showDefault:Bool = true){
        self.tintColor = Colors.clear
        dateFormatType = format
        switch dateFormatType {
        case .date:
            datePicker.datePickerMode = .date
            break
        case .time:
            datePicker.datePickerMode = .time
            break
        case .dateTime:
            datePicker.datePickerMode = .dateAndTime
            break
        }
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        //self.text = datePicker.date.toString(dateFormat: DateFormats.DATE_DISPLAY_FORMAT_OFFSET_10)
        self.inputView = datePicker
        if text!.isEmpty {
            if showDefault {
                self.updateDate()
            }
        }
        
    }
    
    func updateDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatType.rawValue
        selectedDate = datePicker.date
        self.text = formatter.string(from: datePicker.date)
    }
    
    @objc func datePickerChanged(sender: UIDatePicker) {
        updateDate()
    }
    
    @objc func donedatePicker(){
        updateDate()
        self.resignFirstResponder()
    }
    
    func setupPickerview(_ list:[OrderedDictionaryModel],_ value:String = "",_ showDefault:Bool = false){
        self.pickerDataSource = list
        if showDefault && self.pickerDataSource.count > 0 {
            let key = self.pickerDataSource[0].key
            let value = self.pickerDataSource[0].value
            self.selectedId = key
            self.selectedValue = value
            self.text = value
        }
        self.autocorrectionType = .no
        self.tintColor = UIColor.clear
        self.picker.delegate = self
        self.inputView = self.picker
        self.picker.reloadAllComponents()
    }
    
    
    
    func updateKeyboardType(){
        
        if self.valueType == .none {
            self.keyboardType = .default
        }
        else if self.valueType == .onlyNumbers || self.valueType == .phoneNumber {
            self.keyboardType = .numberPad
        }
    }
    
    func resetSelectedData(){
        self.text = ""
        self.selectedId = ""
        self.selectedValue = ""
    }
    
    func setSelectedData(value:String,selId:String) {
        self.text = value
        self.selectedId = selId
        self.selectedValue = value
    }
    
    func setSelectedDateValue(value:String,selDate:Date?) {
        self.text = value
        self.selectedDate = selDate ?? Date()
        self.selectedValue = value
    }
    
}

extension CustomTextField : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.pickerDataSource.count > 0 && self.text == ""{
            self.selectedId = self.pickerDataSource[row].key
            self.selectedValue = self.pickerDataSource[row].value
            self.text = self.selectedValue
        }
        let value = self.pickerDataSource[row].value
        return  value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.pickerDataSource.count > 0 {
            self.selectedId = self.pickerDataSource[row].key
            self.selectedValue = self.pickerDataSource[row].value
            self.text = self.selectedValue
        }
    }
}


extension CustomTextField : UITextFieldDelegate {
    
    @objc fileprivate func textFieldDidChange() {
        self.textInputDelegate?.textInputDidChange?(textField: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.isAutoComplete {
            self.textInputDelegate?.textInputAutoComplete?(textField: textField as! CustomTextField)
            textField.endEditing(true)
        }else{
            self.textInputDelegate?.textInputDidBeginEditing?(textField: textField as! CustomTextField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textInputDelegate?.textInputDidEndEditing?(textField: textField as! CustomTextField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.isAutoComplete {
            self.textInputDelegate?.textInputAutoComplete?(textField: textField as! CustomTextField)
            return false
        }
        _ =  self.textInputDelegate?.textInputShouldBeginEditing?(textField: textField as! CustomTextField)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        _ = self.textInputDelegate?.textInputShouldEndEditing?(textField: textField as! CustomTextField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        _ = self.textInputDelegate?.textInputShouldReturn?(textField: textField as! CustomTextField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle backspace/delete
        guard !string.isEmpty else {
            // Backspace detected, allow text change, no need to process the text any further
            return true
        }
        
        if valueType == .phoneNumber {
            let phoneNumberSet = CharacterSet(charactersIn: "+0123456789")
            if string.rangeOfCharacter(from: phoneNumberSet.inverted) != nil {
                return false
            }
        }else if valueType == .onlyNumbers {
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
        }else if valueType == .onlyLetters {
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }
        else if valueType == .alphaNumeric {
            let alphaNumericSet = CharacterSet.alphanumerics
            if string.rangeOfCharacter(from: alphaNumericSet.inverted) != nil {
                return false
            }
        }
        else if valueType == .fullName {
            var characterSet = CharacterSet.letters
            print(characterSet)
            characterSet = characterSet.union(CharacterSet(charactersIn: " "))
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
        }
        
        if let text = self.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if maxLength > 0, maxLength < finalText.utf8.count {
                return false
            }
        }
        // Check supported custom characters
        if !self.allowedCharInString.isEmpty {
            let customSet = CharacterSet(charactersIn: self.allowedCharInString)
            if string.rangeOfCharacter(from: customSet.inverted) != nil {
                return false
            }
        }
        return true
    }
    
}


extension UIView {
    class func getAllSubviewsOfType<T: UIView>(view: UIView) -> [T]
    {
        return view.subviews.flatMap { subView -> [T] in
            var result = UIView.getAllSubviewsOfType(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }
    
    func getAllSubviewsWithType<T: UIView>() -> [T] {
        return UIView.getAllSubviewsOfType(view: self) as [T]
    }
}


extension CustomTextField {
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(_ direction:Direction,_ image:UIImage,_ colorSeparator:UIColor,_ enable:Bool=false,_ text:String = ""){
        
        var mainViewWidth : CGFloat = 40 // Default text field height
        var mainViewHeight : CGFloat = self.frame.height
        if text != "" {
            mainViewWidth = 100
        }
        if mainViewHeight == 0 {
            mainViewHeight = defaultHeight
        }
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: mainViewWidth, height: mainViewHeight))
        mainView.isUserInteractionEnabled = enable
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: mainViewWidth, height: mainViewHeight))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        mainView.addSubview(view)
        
        let iconImage = image.withRenderingMode(.alwaysTemplate)
        let button = CustomButton() // UIImageView(image: iconImage)
        button.buttonImage = iconImage
        if text != "" {
            button.buttonTitle = text
            button.spacing = 2
            button.imagePosition = .right
            button.titleColor = UIColor.black
            button.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        button.contentMode = .scaleAspectFit
        let iconHeight = view.frame.height/2-12
        let iconXvalue = (mainViewWidth - 24)/2
        if text == "" {
            button.frame = CGRect(x: iconXvalue, y: iconHeight, width: 24.0, height: 24.0)
        }else{
            button.frame = CGRect(x: 5.0, y: iconHeight, width: mainViewWidth, height: 24.0)
        }
        button.tintColor = colorSeparator
        button.addTarget(self, action: #selector(self.rightButtonClicked), for: .touchUpInside)
        view.addSubview(button)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: mainViewWidth - 5, y: 5, width: 1, height: mainViewHeight-10)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 5, width: 1, height: mainViewHeight-10)
            self.rightViewMode = .always
            self.rightView = mainView
        }
    }
    
}


extension CustomTextField {
    func setCommonTextField(_ placeHolder:String) {
        self.initSetup()
        self.placeholder = placeHolder
        self.cornerRadius = 5
        self.setBorder(1.0, Colors.separator)
        self.font = CustomFonts.getRegularFont(.NORMAL)
    }
    
    func setDropdownArrow(){
        self.withImage(.Right, ImageNames.expand, Colors.separator)
    }
    
    func setRightSideImage(_ image:UIImage){
        self.withImage(.Right, image, Colors.gray)
    }
}


extension CustomTextField {
    
    func getServerDate() -> String {
        return self.selectedDate.toString(DateFormatsList.Server_Date)
    }
    
    func getDisplayDate() -> String {
        return self.selectedDate.toString(DateFormatsList.Display_Date)
    }
}


