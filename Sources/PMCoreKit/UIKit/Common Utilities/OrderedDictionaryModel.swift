//
//  OrderedDictionary.swift
//  SwiftUISample
//
//  Created by sn99 on 25/09/19.
//  Copyright © 2019 sn99. All rights reserved.
//

import Foundation
import UIKit




let newLine = "\n"


struct OrderedDictionaryModel {
    var key = ""
    var value = ""
}


struct TableViewObjectModel {
    var key = ""
    var value = ""
    var image : UIImage? = nil
    
    init(_ key1:String,_ value1:String,_ image1:UIImage? = nil) {
        self.key = key1
        self.value = value1
        self.image = image1
    }
}

struct GroupedObjectModel {
    var headerTitle = ""
    var footerTitle = ""
    var list = [TableViewObjectModel]()
    
    init(_ header:String,_ footer:String,_ items:[TableViewObjectModel]) {
        self.headerTitle = header
        self.footerTitle = footer
        self.list = items
    }
}




class EditTextModel {
    var title = ""
    var data = ""
    var dropdownId = ""
    var isEnable = true
    var valueType = TextFieldType.none
    var keyboardType = UIKeyboardType.default
    var maxLength = 0
    var dropdownData = [OrderedDictionaryModel]()
    
    
    init(_ title1:String,_ data1:String,_ editable:Bool) {
        self.title = title1
        self.data = data1
        self.isEnable = editable
    }
    
}




