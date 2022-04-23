//
//  CustomExtensions.swift
//  BMS
//
//  Created by Sekhar on 16/12/18.
//  Copyright © 2018 Sekhar n. All rights reserved.
//

import Foundation
import UIKit



//MARK: - Bundle Extension
extension Bundle {
    var displayName: String {
        return infoDictionary?[kCFBundleNameKey as String] as? String  ?? "Fleet+"
    }
    var version: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    var build: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}




//MARK: - DispatchQueue Extension
extension DispatchQueue {
    
    static public func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}


//MARK: - Double Extension
public extension Double {
    
    var stringValue : String {
        return  String(describing: self)
    }
    
    func toInt() -> Int {
        guard (self <= Double(Int.max).nextDown) && (self >= Double(Int.min).nextUp) else {
            return 0
        }
        return Int(self)
    }
    
    func rounded(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    
    func toDecimal(_ places:Int) -> String {
        return String(format: "%.\(places)f", self)
    }
    
    func asString(_ style:DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
    
}



//MARK: - Dictionary Extension
extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "{\(key)=\(value)}"
        }
        return output
    }
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}


//MARK: - String Extension
public extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment:"")
    }
    
    func repeatString(count:Int) -> String {
        return String(repeating: self, count: count)
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var length: Int {
        get {
            return self.count
        }
    }
    
    //    var isNumeric: Bool {
    //        guard self.count > 0 else { return false }
    //        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    //        return Set(self).isSubset(of: nums)
    //    }
    
    var isUrl : Bool {
        return self.lowercased().starts(with: "http://") || self.lowercased().starts(with: "https://")
    }
    
    var doubleValue : Double
    {
        return Double(self) ?? NumberFormatter().number(from: self)?.doubleValue ?? 0
    }
    
    var intValue: Int
    {
        return (self as NSString).integerValue // Int(self) ?? 0
    }
    
    var cgFloatValue: CGFloat
    {
        return CGFloat(self.intValue)
    }
    
    
    var boolValue: Bool {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return false
        }
    }
    
    var switchValue : String {
        if self == "true" {
            return "ON"
        }
        return "OFF"
    }
    
    
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , leftRange.upperBound <= rightRange.lowerBound
        else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailPred.evaluate(with: self)
        return result
    }
    
    func isValidatePhoneNumber() -> Bool {
        if self.isAllDigits() == true {
            let phoneRegex = "[2356789][0-9]{6}([0-9]{3})?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return  predicate.evaluate(with: self)
        }else {
            return false
        }
    }
    private func isAllDigits()->Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    
    func character(_ at: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: at)]
    }
    
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    func replace(_ string:String,_ replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 16)) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height + 20)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width + 20)
    }
    
    
    var toData: Data? {
        return self.data(using: String.Encoding.utf8)
    }
    
    var toUrl: URL? {
        return URL(string: self.replace(" ", "%20"))
    }
    var toFileUrl: URL {
        return URL(fileURLWithPath: self)
    }
    var pathExtension: String {
        return (self as NSString).pathExtension 
    }
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    var deletingPathExtension : String {
        return (self as NSString).deletingPathExtension
    }
    
    func contentsOrBlank()->String {
        var fileContent = ""
        if FileManager.default.fileExists(atPath: self) {
            do {
                fileContent = try String(contentsOfFile: self, encoding: .utf8)
                print(fileContent)
            } catch {
                print("Failed to read text from \(self)")
            }
        }
        return fileContent
    }
    
    var isValidImageData : Bool {
        do {
            if let url = self.toUrl {
                let imageData = try Data(contentsOf: url)
                if UIImage(data: imageData) != nil {
                    return true
                }
            }else{
                return false
            }
        } catch {
            print("Error isValidImageData : \(error)")
        }
        return false
    }
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? self
    }
    
    func convertHtml() -> NSMutableAttributedString{
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            
            //            let attributes:[NSAttributedString.Key : Any] = [
            //                .font : CustomFonts.getRegularFont(.NORMAL),
            //            ]
            
            let attrStrng = NSMutableAttributedString(attributedString: attributedString)
            
            return attrStrng
        }
        return NSMutableAttributedString()
    }
    
    var maskEmail: String {
        let email = self
        let components = email.components(separatedBy: "@")
        var maskEmail = ""
        if let first = components.first {
            maskEmail = String(first.enumerated().map { index, char in
                return [0, 1, first.count - 1, first.count - 2].contains(index) ?
                    char : "*"
            })
        }
        if let last = components.last {
            maskEmail = maskEmail + "@" + last
        }
        return maskEmail
    }
    
    
    var maskPhoneNumber: String {
        return String(self.enumerated().map { index, char in
            return [0, 3, self.count - 1, self.count - 2].contains(index) ?
                char : "X"
        })
    }
    
    func replaceFirst(_ string: String,_ replacement: String) -> String
    {
        if let range = self.range(of: string) {
            return self.replacingCharacters(in: range, with: replacement)
        }
        return self
    }
    
    func sizeWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.size
    }
    
    var displayBoolValue : String {
        if self.boolValue {
            return "Yes"
        }
        else{
            return "No"
        }
    }
    
}


//MARK: - NSAttributedString Extension
extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
    
    
}


extension NSMutableAttributedString {
    var fontSize:CGFloat { return 17 }
    var boldFont:UIFont { return UIFont.systemFont(ofSize: fontSize, weight: .bold) }
    var normalFont:UIFont { return UIFont.systemFont(ofSize: fontSize, weight: .regular)}
    
    
    func text(_ value:String,_ color:UIColor,_ font:UIFont? = nil) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font ?? normalFont,
            .foregroundColor : color
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    
    func underlined(_ value:String,_ color:UIColor,_ font:UIFont? = nil) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font ?? normalFont,
            .foregroundColor : color,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func color(_ value:String,_ color:UIColor) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
            .foregroundColor : color
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func icon(image:UIImage,width:CGFloat = 0,height:CGFloat = 0) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: 17)
        let attachment = NSTextAttachment()
        attachment.image = image
        
        
        if let attachImage = attachment.image{
            var imageSize = attachImage.size
            if width > 0 && height > 0 {
                imageSize = CGSize(width: width, height: height)
            }
            attachment.bounds = CGRect(x: CGFloat(0), y: (font.capHeight - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        }
        let attachmentString = NSAttributedString(attachment: attachment)
        self.append(attachmentString)
        return self
    }
    
    func background(_ value:String,_ color:UIColor,_ bgColor:UIColor,_ font:UIFont? = nil) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font ?? normalFont,
            .foregroundColor : color,
            .backgroundColor : bgColor
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func getAttachmentString(_ image:UIImage,_ text:String) -> NSMutableAttributedString{
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = image
        
        let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
        let myString:NSMutableAttributedString = NSMutableAttributedString(string: text + "  ")
        myString.append(attachmentString)
        return myString
    }
    
    func lineSpacing(spacing:CGFloat) -> NSMutableAttributedString{
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: self.length))
        return self
    }
    
    func textAlignment(alignment:NSTextAlignment) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        
        let attributes:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key.paragraphStyle: style
        ]
        self.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return self
    }
    
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
}


//MARK: - Bool Extension
extension Bool {
    
    var intValue: Int {
        return self ? 1 : 0
    }
    
    var stringValue : String {
        return self ? "true" : "false"  // Replace If condition in single statement
    }
    
    var serverValue : String {
        return self ? "Y" : "N"  
    }
    
    
}


//MARK: - Int Extension
extension Int {
    
    var boolValue: Bool {
        return self != 0
    }
    
    var array: [Int] {
        return String(self).compactMap{ Int(String($0)) }
    }
    
    var stringValue : String {
        return String(self)
    }
    
    func firstDigit() -> Int {
        let numbers = self.array
        if numbers.count > 0 {
            return numbers[0]
        }else{
            return 0
        }
    }
}



//MARK: - URL Extension
extension URL {
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: Double {
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: path)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
    var fileNameWithoutExt: String {
        return self.lastPathComponent.deletingPathExtension
    }
    
    var fileNameWithExt: String {
        return self.lastPathComponent
    }
    
    func covertToFileString(with size: Double) -> String {
        var convertedValue = size
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.1f %@", convertedValue, tokens[multiplyFactor])
    }
    
    func getFileSize() -> String {
        return covertToFileString(with: self.fileSize)
    }
    
    var stringValue : String {
        return self.path
    }
    
    var fullPath : String {
        return self.absoluteString
    }
    
    var isValidImageData : Bool {
        do {
            let imageData = try Data(contentsOf: self)
            if UIImage(data: imageData) != nil {
                return true
            }
        } catch {
            print("isValidImageData : \(error)")
        }
        return false
    }
    
    func getImage() -> UIImage? {
        do {
            let imageData = try Data(contentsOf: self)
            if let image = UIImage(data: imageData) {
                return image
            }
        } catch {
            print("isValidImageData : \(error)")
        }
        return nil
    }
    
    static  let fileManager = FileManager.default
    
    static func isFileExists(filePath : URL)-> Bool{
        if FileManager.default.fileExists(atPath: filePath.path){
            return true
        }
        return false
    }
    
    static func getFileSize(fileUrl : URL) -> Int64{
        let filePath = fileUrl.absoluteString
        var fileSize : UInt64
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            return   Int64(bitPattern: fileSize)
        } catch {
            print("Error: \(error)")
        }
        return 0
    }
    
}


//MARK: - Data Extension
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


//MARK: - HTTPURLResponse Extension
public extension HTTPURLResponse {
    var isSuccess : Bool {
        get {
            return self.statusCode == 200
        }
    }
    var isNewFileCreated : Bool {
        get {
            return self.statusCode == 201
        }
    }
    var isNoDataAvailable : Bool {
        get {
            return self.statusCode == 404
        }
    }
    func getErrorInformation(_ response: [String: Any]) -> String{
        if let errorMsg = response["message"] as? String {
            return errorMsg
        }
        return "kUnknownError"
    }
}


//MARK: - Error Extension
extension Error {
    var message : String {return self.localizedDescription}
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}


extension Array {
    
    mutating func randomElements(elements n: Int) -> [Element] {
        var returnCount = n
        if returnCount >= self.count {
            returnCount = self.count
        }
        for i in stride(from: self.count - 1, to: self.count - returnCount - 1, by: -1) {
            let randomIndex = Int(arc4random_uniform(UInt32(i + 1)))
            self.swapAt(i, randomIndex)
        }
        return self.suffix(returnCount)
    }
    
    func isValidIndex(_ index : Int) -> Bool {
        return index < self.count
    }
}



// MARK: - String By Words
extension String {
    
    var byWords: [String] {
        return self.components(separatedBy: " ")
    }
    
    var bySentenses: [String] {
        return self.components(separatedBy: "\n")
    }
    
    func firstWords(_ max: Int) -> [String] {
        return Array(byWords.prefix(max))
    }
    var firstWord: String {
        return byWords.first ?? ""
    }
    func lastWords(_ max: Int) -> [String] {
        return Array(byWords.suffix(max))
    }
    var lastWord: String {
        return byWords.last ?? ""
    }
    
    func words(_ seperatedBy:String) -> [String] {
       return self.components(separatedBy: ",")
    }

}

extension String {
    func verifyUrl () -> Bool {
        if let url = self.toUrl {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
