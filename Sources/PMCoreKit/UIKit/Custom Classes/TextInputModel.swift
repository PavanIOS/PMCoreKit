

import Foundation
import UIKit



enum InputFieldType : Int {
    case None = 0
    case SINGLE_LINE_TF
    case MULTI_LINE_TF
    case NUMBER_TF
    case DROP_DOWN
    case DATE
    case DATE_TIME
    case TIME
    case BUTTON
    case SINGLE_SELECTION
    case MULTI_SELECTION
    case SECTION_TITLE
    case DETAIL_TEXT
    case RIGHT_DETAIL_TEXT
    case CHECK_MARK
    case TAGS
    case EXPAND_DELETE
    case RADIO_BUTTON
    case SIDE_BY_SIDE_TF
    case SIGNATURE
    case QUESTION
    case MEDIA
    case SLIDER
    case SWITCH
    case SMART_FIELD
    
}

enum CellTypes : Int {
    case EMPTY_TABLE_CELL = 0
    case INPUT_CELL
    case RIGHT_DETAIL_CELL
    case CUSTOM
}

enum SectionTypes : Int {
    case NONE =  0
    case PLAIN
    case EXPAND
    case EXPAND_DELETE
}



class TextInputModel {
    var title = ""
    var data = ""
    var fieldId = ""
    var level = 0
    var token = Device.getToken
    var subToken = ""
    var placeHolder = ""
    var textColor = Colors.black
    var bgColor = Colors.white
    var headerTitle = ""
    var enable = true
    var selectedId = ""
    var titleAlignment = NSTextAlignment.left
    var valueAlignment = NSTextAlignment.left
    var fieldType = InputFieldType.None
  //  var cellType = CellTypes.EMPTY_TABLE_CELL
    var valueType = TextFieldType.none
    var keyboardType = UIKeyboardType.default
    var titleFont = CustomFonts.getRegularFont(.SHORT)
    var dataFont = CustomFonts.getRegularFont(.MEDIUM)
    var maxLength = 0
    var dropDownData = [OrderedDictionaryModel]()
    var selList = [OrderedDictionaryModel]()
    var isHidden = false
    
    var isMandatory = false
    var isSelectable = false
    var isSelected = false
    var model : Any?
    var isCanDelete = false
    var minimumDate : Date? = nil
    var maximumDate : Date? = nil
    var fileUrl = ""
    
    
    // App Based Fields
   // var fieldModel = CheckListDataModel()
   // var sectionPropertyModel : SectionFieldPropertiesModel? = nil
   
    var mediaList = [Any]()
    
    
    
    
    func getTextFieldTypes() -> [InputFieldType]{
        var types = [InputFieldType]()
        types.append(.SINGLE_LINE_TF)
        types.append(.NUMBER_TF)
        types.append(.DROP_DOWN)
        types.append(.DATE)
        types.append(.DATE_TIME)
        types.append(.TIME)
        types.append(.SIDE_BY_SIDE_TF)
        types.append(.MULTI_SELECTION)
        
        return types
    }
    
    func getTextViewTypes() -> [InputFieldType]{
        var types = [InputFieldType]()
        types.append(.MULTI_LINE_TF)
        return types
    }
    
    func getTagsType() -> [InputFieldType]{
        var types = [InputFieldType]()
        types.append(.TAGS)
        return types
    }
    
    func isInputCellType() -> Bool {
        return getTextFieldTypes().contains(fieldType) || getTextViewTypes().contains(fieldType) || getTagsType().contains(fieldType) || fieldType == .BUTTON || fieldType == .RADIO_BUTTON
    }
    
}


class InputFieldModel {
    var fields = [TextInputModel]()
    var sectionTitle = ""
    var footerTitle = ""
    var sectionType = SectionTypes.NONE
}






func getDetailsFieldType(_ title:String,_ value:String) -> TextInputModel {
    let model = TextInputModel()
    model.title = title
    model.data = value
    model.fieldType = .DETAIL_TEXT
    return model
}

func getSingleLineField(_ title:String,_ value:String) -> TextInputModel {
    let model = TextInputModel()
    model.title = title
    model.data = value
    model.fieldType = .SINGLE_LINE_TF
    model.placeHolder = "Enter Text"
   // model.cellType = .INPUT_CELL
    return model
}



func getSignatureFieldType(_ title:String,_ value:String,_ fileUrl:String) -> TextInputModel {
    let model = TextInputModel()
    model.title = title
    model.data = value
    model.fieldType = .SIGNATURE
   // model.cellType = .CUSTOM
    model.fileUrl = fileUrl
    return model
}

func getCheckMarkFieldType(_ title:String,_ value:String,_ isSelected:Bool) -> TextInputModel {
    let model = TextInputModel()
    model.title = title
    model.data = value
    model.fieldType = .CHECK_MARK
   // model.cellType = .CUSTOM
    return model
}



