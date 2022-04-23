//
//  InputStackTableViewCell.swift
//  MuvyrDriver
//
//  Created by sn99 on 23/03/21.
//  Copyright © 2021 Gpinfotech. All rights reserved.
//

import UIKit
import SDWebImage


class InputStackTableViewCell: CustomTableViewCell {
    
    @IBOutlet weak var bgStackView: CustomStackView!
    @IBOutlet weak var titleLbl: CustomLabel!
    
    @IBOutlet weak var stackLeadingConstant: NSLayoutConstraint!
    
    
    static let cellId = "InputStackTableViewCell"
    
    
    
    override func prepareForReuse() {
        self.bgStackView.removeBorders()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initCell()
    {
        self.selectionStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        self.accessoryView = nil
        
        self.titleLbl.numberOfLines = 0
        self.titleLbl.font = CustomFonts.getRegularFont(.NORMAL)
        
        self.bgStackView.translatesAutoresizingMaskIntoConstraints = false
        self.bgStackView.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.bgStackView.removeBorders()
    }
    
    
    
    func updateCellData(_ model:TextInputModel,_ indexPath:IndexPath) {
        
        let subviews = self.bgStackView.arrangedSubviews
        for subview in subviews {
            if subview != titleLbl {
                subview.removeFromSuperview()
            }
        }
        self.accessoryView = nil
        
        if model.level > 0 {
            let level = CGFloat(model.level) * 5
            self.stackLeadingConstant.constant = level
            self.bgStackView.addBorder(on: [.left(thickness: 5, color: Colors.themeYellow)])
        }else{
            self.bgStackView.removeBorders()
            self.stackLeadingConstant.constant = 0
        }
        
        if model.isMandatory {
            self.titleLbl.attributedText = NSMutableAttributedString().text(model.title + " ", Colors.black, CustomFonts.getRegularFont(.NORMAL)).icon(image: ImageNames.mandatory, width: 10, height: 10)
        }else{
            self.titleLbl.text = model.title
        }
        
        if model.getTextFieldTypes().contains(model.fieldType){
            showTextField(model,indexPath)
        }
        else if model.getTextViewTypes().contains(model.fieldType) {
            showTextView(model,indexPath)
        }
        else if model.fieldType == .SLIDER{
            showSlider(model,indexPath)
        }
        else if model.fieldType == .CHECK_MARK {
            showCheckBox(model,indexPath)
        }
        else if model.fieldType == .SWITCH {
            showSwitch(model,indexPath)
        }
        else if model.fieldType == .QUESTION {
            showQuestion(model,indexPath)
        }
        else if model.fieldType == .MEDIA {
            showMedia(model,indexPath)
        }
        
    }
    
    
    func dataDidChange(_ data:String,_ selectedId:String,_ section:Int,_ row:Int,_ item:Int,_ reload:Bool) -> DelegateParser{
        let parser = DelegateParser()
        parser.data = data
        parser.selectedId = selectedId
        parser.section = section
        parser.row = row
        parser.item = item
        parser.isToBeReload = reload
        
        return parser
    }
    
}


// MARK: Text Field
extension InputStackTableViewCell {
    
    func showTextField(_ model:TextInputModel,_ indexPath:IndexPath){
        let textField = CustomTextField()
        textField.section = indexPath.section
        textField.row = indexPath.row
        
        textField.font = CustomFonts.getRegularFont(.MEDIUM)
        textField.borderStyle = .roundedRect
        textField.initSetup()
        textField.setBorder(1.0, Colors.lightGray.withAlphaComponent(0.5))
        textField.cornerRadius = 8
        
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textField.placeholder = model.title
        textField.isEnabled = model.enable
        
        textField.text = model.data
        textField.maxLength = model.maxLength
        
        if model.enable {
            textField.backgroundColor = .white
        }else{
            textField.backgroundColor = Colors.disableColor
        }
        
        if model.fieldType == .SINGLE_LINE_TF || model.fieldType == .NUMBER_TF {
            textField.removeDropDown()
            
            if model.placeHolder == "" {
                if model.fieldType == .SINGLE_LINE_TF {
                    textField.placeholder = "Enter Text"
                }else {
                    textField.placeholder = "Enter Value"
                }
            }
        }
        else if model.fieldType == .MULTI_SELECTION {
            textField.withImage(.Right, ImageNames.downArrow, .lightGray)
            textField.isAutoComplete = true
        }
        
        else if model.fieldType == .DROP_DOWN {
            textField.withImage(.Right, ImageNames.downArrow, .lightGray)
            textField.setupPickerview(model.dropDownData, model.data)
            if model.placeHolder == "" {
                textField.placeholder = "Select"
            }
        }else if model.fieldType == .DATE {
            textField.withImage(.Right, ImageNames.downArrow, .lightGray)
            textField.setupDatePicker(.date, false)
            if model.placeHolder == "" {
                textField.placeholder = "Select"
            }
            
        }else if model.fieldType == .DATE_TIME {
            textField.withImage(.Right, ImageNames.downArrow, .lightGray)
            textField.setupDatePicker(.dateTime, false)
            if model.placeHolder == "" {
                textField.placeholder = "Select"
            }
        }
        
        textField.textInputDelegate = self
        self.bgStackView.addArrangedSubview(textField)
    }
}



// MARK: - Text View
extension InputStackTableViewCell {
    func showTextView(_ model:TextInputModel,_ indexPath:IndexPath){
        let textView = CustomTextView()
        textView.section = indexPath.section
        textView.row = indexPath.row
        
        textView.autocorrectionType = .no
        textView.font = CustomFonts.getRegularFont(.MEDIUM)
        textView.initSetup()
        textView.setBorder(1.0, Colors.lightGray.withAlphaComponent(0.5))
        textView.cornerRadius = 8
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        textView.text = model.data
        textView.hideAndShowPlaceHolder()
        textView.isEditable = model.enable
        if model.enable {
            textView.backgroundColor = .white
        }else{
            textView.backgroundColor = Colors.disableColor
        }
        textView.maxLength = model.maxLength
        textView.textInputDelegate = self
        self.bgStackView.addArrangedSubview(textView)
    }
}

// MARK: - Check Box
extension InputStackTableViewCell {
    func showCheckBox(_ model:TextInputModel,_ indexPath:IndexPath) {
        
        let checkboxButton = CustomButton()
        checkboxButton.initSetup()
        checkboxButton.section = indexPath.section
        checkboxButton.row = indexPath.row
        
        checkboxButton.frame.size = CGSize(width: 40, height: 40)
        checkboxButton.contentMode = .scaleAspectFit
        
        if model.data.boolValue {
            checkboxButton.buttonImage = ImageNames.checkbox
        }else{
            checkboxButton.buttonImage = ImageNames.uncheck
        }
        
        checkboxButton.addTarget(self, action: #selector(checkBoxClicked(_:)), for: .touchUpInside)
        
        self.accessoryView = checkboxButton
    }
    
    @objc func checkBoxClicked(_ sender:CustomButton) {
        var data = "off"
        if sender.currentImage == ImageNames.uncheck {
            data = "on"
        }
        let parser = dataDidChange(data, "", sender.section, sender.row,sender.item, true)
        parser.id = sender.id
        parser.fieldType = .CHECK_MARK
        delegate?.didChangeValue(parser)
    }
}



// MARK: - Question
extension InputStackTableViewCell {
    
    func showQuestion(_ model:TextInputModel,_ indexPath:IndexPath) {
        let stackView = CustomStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
//        if let sectionModel = model.sectionPropertyModel , sectionModel.getResponses().count > 0 {
//            for (index,item) in sectionModel.getResponses().enumerated() {
//                let button = CustomButton()
//                button.initSetup()
//                button.section = indexPath.section
//                button.row = indexPath.row
//                button.item = index
//                button.id = item.ResponseID.stringValue
//                button.buttonTitle = item.Text
//                button.titleColor = Colors.white
//                button.cornerRadius = 8
//                if item.ResponseID.stringValue == model.selectedId {
//                    button.backgroundColor = item.getColor()
//                }else{
//                    button.backgroundColor = item.getDefaultColor()
//                }
//
//                button.addTarget(self, action: #selector(questionAnswerClicked(_:)), for: .touchUpInside)
//                stackView.addArrangedSubview(button)
//            }
//            self.bgStackView.addArrangedSubview(stackView)
//        }
    }
    
    @objc func questionAnswerClicked(_ sender:CustomButton) {
        let parser = dataDidChange(sender.buttonTitle, "", sender.section, sender.row,sender.item, true)
        parser.selectedId = sender.id
        parser.fieldType = .QUESTION
        delegate?.didChangeValue(parser)
    }
}

// MARK: - Media
extension InputStackTableViewCell {
    
    func showMedia(_ model:TextInputModel,_ indexPath:IndexPath) {
        
        let button = CustomButton()
        button.initSetup()
        button.section = indexPath.section
        button.row = indexPath.row
        
        button.buttonTitle = "Add Media"
        button.backgroundColor = Colors.themeColor
        
        let mediaStackView = CustomStackView()
        mediaStackView.axis = .horizontal
        mediaStackView.distribution = .fillEqually
        mediaStackView.spacing = 10
        mediaStackView.translatesAutoresizingMaskIntoConstraints = false
        mediaStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        for mediaItem in model.mediaList {
            let imageView = CustomImageView()
            if let item = mediaItem as? String {
                imageView.sd_setImage(with: item.toUrl, completed: nil)
                mediaStackView.addArrangedSubview(imageView)
            }
        }
        
        self.bgStackView.addArrangedSubview(button)
        if mediaStackView.arrangedSubviews.count > 0 {
            self.bgStackView.addArrangedSubview(mediaStackView)
        }
    }
}

// MARK: - Slider
extension InputStackTableViewCell {
    func showSlider(_ model:TextInputModel,_ indexPath:IndexPath) {
        
        let stackView = CustomStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let minLbl = CustomLabel()
        let maxLbl = CustomLabel()
        
        
        let slider = UISlider()
        
//        if let propertyModel = model.sectionPropertyModel {
//            slider.minimumValue = Float(propertyModel.SliderMinimum)
//            slider.maximumValue = Float(propertyModel.SliderMaximum)
//            minLbl.text = propertyModel.SliderMinimum.stringValue
//            maxLbl.text = propertyModel.SliderMaximum.stringValue
//
//            slider.accessibilityIdentifier = propertyModel.SliderIncrement.stringValue
//        }
        
        
        slider.tag = indexPath.section
        slider.accessibilityIdentifier = indexPath.row.stringValue
        slider.addTarget(self, action: #selector(sliderValueChanged(_:_:)), for: .valueChanged)
        
        slider.value = Float(model.data) ?? 0
        
        stackView.addArrangedSubview(minLbl)
        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(maxLbl)
        self.bgStackView.addArrangedSubview(stackView)
    }
    
    @objc func sliderValueChanged(_ sender:UISlider,_ event: UIEvent) {
        
        if let touchEvent = event.allTouches?.first {
            if touchEvent.phase == .ended {
               
                if let step: Float = sender.accessibilityIdentifier?.floatValue {
                    let roundedValue = round(sender.value / step) * step
                    sender.value = roundedValue
                }
                
                let parser = DelegateParser()
                parser.section = sender.tag
                parser.row = sender.accessibilityIdentifier?.intValue ?? 0
                parser.data = String(Int(round(sender.value)))
                delegate?.didChangeValue(parser)
            }
        }
    }
    
}

// MARK: - Switch
extension InputStackTableViewCell {
    
    func showSwitch(_ model:TextInputModel,_ indexPath:IndexPath) {
        let cSwitch = CustomSwitch()
        cSwitch.section = indexPath.section
        cSwitch.row = indexPath.row
        
        cSwitch.setOn(model.data.boolValue, animated: true)
        
        cSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        self.accessoryView = cSwitch
    }
    
    @objc func switchValueChanged(_ sender:CustomSwitch) {
        let parser = DelegateParser()
        parser.section = sender.section
        parser.row = sender.row
        if sender.isOn {
            parser.data = "on"
        }else{
            parser.data = "off"
        }
        delegate?.didChangeValue(parser)
    }
}





extension InputStackTableViewCell : CustomTextFieldDelegate {
    
    func textInputDidChange(textField: CustomTextField) {
//        let parser = dataDidChange(textField.text!, textField.selectedId, textField.section, textField.row,0, false)
//        delegate?.didChangeValue(parser)
    }
    
    func textInputDidEndEditing(textField: CustomTextField) {
        let parser = dataDidChange(textField.text!, textField.selectedId, textField.section, textField.row,0, true)
        delegate?.didChangeValue(parser)
    }
    
    func textInputAutoComplete(textField: CustomTextField) {
        let parser = dataDidChange(textField.text!, textField.selectedId, textField.section, textField.row,0, false)
        delegate?.autoComplete(parser)
    }
    
    
}

extension InputStackTableViewCell : CustomTextViewDelegate {
    func textViewDidChange(_ textView: CustomTextView) {
        //        let parser = dataDidChange(textView.text, "", textView.section, textView.row, 0, false)
        //        parser.fieldType = .MULTI_LINE_TF
        //        delegate?.didChangeValue(parser)
    }
    
    func textViewDidEndEditing(_ textView: CustomTextView) {
        let parser = dataDidChange(textView.text, "", textView.section, textView.row,0, true)
        parser.fieldType = .MULTI_LINE_TF
        delegate?.didChangeValue(parser)
    }
}
