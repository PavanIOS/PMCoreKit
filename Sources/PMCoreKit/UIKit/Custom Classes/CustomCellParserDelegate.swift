



import Foundation




public class DelegateParser {
    var section = 0
    var row = 0
    var item = 0
    var tag = 0
    var data = ""
    var oldData = ""
    var selectedId = ""
    var type = ""
    var selDate = Date()
    var sender : Any?
    var isToBeReload = false
    var id = ""
    var isSelected = false
    var fieldType : InputFieldType = .None
    var fileUrl : URL?
}

protocol CustomCellParserDelegate : AnyObject {
    func didChangeValue(_ parser:DelegateParser)
    func autoComplete(_ parser:DelegateParser)
    
}

public extension CustomCellParserDelegate {
    func didChangeValue(_ parser:DelegateParser) {
        
    }
    
    func autoComplete(_ parser:DelegateParser) {
        
    }
}
