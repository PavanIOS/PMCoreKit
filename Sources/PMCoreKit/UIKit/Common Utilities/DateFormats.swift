//
//  DateFormats.swift
//  WBT
//
//  Created by pavan M. on 2/4/19.
//  Copyright © 2019 Sekhar n. All rights reserved.
//

import Foundation

class DateFormatsList {
    static let fullDay = "EEEE"
    static let fullMonth = "MMMM"
    static let fullYear = "YYYY"
    static let shortDay = "EEE"
    static let shortMonth = "MMM"
    static let date = "dd"
    static let month = "MM"
    static let year = "YY"
    static let hh = "HH"
    static let mm = "mm"
    static let ss = "ss"
    
    
    static let Server_Date = "yyyy/MM/dd"
    static let Server_Time = "HH:mm"
    static let Server_Date_Time = Server_Date + " " + Server_Time
    
    static let Parser_Date = "dd-MM-yyyy"
    static let Parser_Time = "HH:mm"
    static let Parser_Date_Time = Parser_Date + " " + Parser_Time
    
    static let Display_Date = "dd-MMM-yyyy"
    static let Display_Time = "hh:mm a"
    static let Display_Date_Time = Display_Date + " " + Display_Time
    
    static let WEEK_DAY_DISPLAY = "EEE,dd,MMM yyyy"
    static let WEEK_DAY_DISPLAY_TIME = WEEK_DAY_DISPLAY + " " + "hh:mm a"
   
    
}


class DateFormats {
    
//    static let WEEK_DAY_DISPLAY = "EEE,dd,MMM yyyy"
//    static let WEEK_DAY_DISPLAY_TIME = WEEK_DAY_DISPLAY + " " + "hh:mm a"
//    static let SERVER_TIME = "HH:mm"
//    static let PARSER_DATE_FORMAT_DD_MM_YYYY = "dd-MM-yyyy"
//    static let PARSER_TIME_FORMAT_HH_MM = SERVER_TIME
//    static let PARSER_DATE_TIME_FORMAT_DD_MM_YYYY = PARSER_DATE_FORMAT_DD_MM_YYYY + " " + "HH:mm"
    
    public static func getServerDate(date:Date,isTimeTrim:Bool)->String {
        
        var dateFormat = DateFormatsList.Server_Date_Time
        if(isTimeTrim){
            dateFormat = DateFormatsList.Server_Date
        }
        var strDate = date.toString(dateFormat)
        
        if(isTimeTrim){
            strDate = strDate + " " + "00:00:00"
        }
        return strDate
    }
    
    public static func getServerTodayDate(isTimeTrim:Bool) -> String{
        let date = Date()
        return getServerDate(date:date,isTimeTrim:isTimeTrim)
    }

    
    static func getTimeStamp(date:Date) -> String {
        let timeStamp = Int64(date.timeIntervalSince1970 * 1000)
        return String(timeStamp)
    }
    static func getDateFromTimestamp(timestamp:Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let serverDate = self.getServerDate(date: date, isTimeTrim: true)
        return serverDate
    }
    
   static func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSinceNow * 1000)
    }
 
    
// convert an NSDate object to a timestamp string
static func convertToTimestamp(date: Date) -> String {
    return String(Int64(date.timeIntervalSince1970 * 1000))
}

   static func getTimeFromServer(completionHandler:@escaping (_ getResDate: Date) -> Void){
        let url = URL(string: "https://www.apple.com")
    let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
        if let httpResponse = response as? HTTPURLResponse {
            if let contentType = httpResponse.allHeaderFields["Date"] as? String {
                //print(httpResponse)
                let dFormatter = DateFormatter()
                dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                // let serverTime = dFormatter.date(from: contentType)
                let serverTime = contentType.toDate("EEE, dd MMM yyyy HH:mm:ss z")
                completionHandler(serverTime ?? Date())
            }
        }
        
    }
        task.resume()
    }
    
}


extension Date
{
    func toString(_ format:String ) -> String
    {
        
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    var calendar: Calendar {
           // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
           return Calendar(identifier: Calendar.current.identifier)
       }
    
    func addDays(_ days:Int) -> Date {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: self) {
            return newDate
        }
        return self
    }
    
    func addHours(_ hours:Int) -> Date {
           if let newDate = Calendar.current.date(byAdding: .hour, value: hours, to: self) {
               return newDate
           }
           return self
       }
    func addMinutes(_ minuts:Int) -> Date {
        if let newDate = Calendar.current.date(byAdding: .minute, value: minuts, to: self) {
            return newDate
        }
        return self
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    var ConvertToLocalDate : Date {
        
        if let convertedDate = self.toString( DateFormatsList.Server_Date_Time).toDate(DateFormatsList.Server_Date_Time) {
            
            return convertedDate
        }
        return self
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return self }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)!.ConvertToLocalDate
    }
    
    var endOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return self }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)!.ConvertToLocalDate
    }
    
    var startOfWeek1: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek1: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
    
    
    func getWeekDates() -> (prevWeek:[Date],thisWeek:[Date],thisWeekDates:[String]) {
        var tuple: (prevWeek:[Date],thisWeek:[Date],thisWeekDates:[String])
        var arrPreWeek: [Date] = []
        var thisweek = [String]()
        for i in 0..<7 {
            let currentDate = Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!
            arrPreWeek.append(currentDate.ConvertToLocalDate)
            let day = DateFormats.getServerDate(date: currentDate, isTimeTrim: true)
            thisweek.append(day)
        }
        var arrThisWeek: [Date] = []
        for i in 1...7 {
             let currentDate = Calendar.current.date(byAdding: .day, value: i, to: arrPreWeek.last!)!
            arrThisWeek.append(currentDate)
            
        }
        tuple = (prevWeek: arrPreWeek,thisWeek: arrThisWeek,thisWeekDates: thisweek)
        return tuple
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        var result: String = ""
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        if days(from: date)    > 0 { result = result + " " + "\(days(from: date)) D" }
        if hours(from: date)   > 0 { result = result + " " + "\(hours(from: date)) H" }
        if minutes(from: date) > 0 { result = result + " " + "\(minutes(from: date)) M" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        return ""
    }
    
    
    /// SwifterSwift: Check if date is in future.
    ///
    ///     Date(timeInterval: 100, since: Date()).isInFuture -> true
    ///
    var isInFuture: Bool {
        return self > Date()
    }
    
    /// SwifterSwift: Check if date is within today.
       ///
       ///     Date().isInToday -> true
       ///
    var isInToday: Bool {
        return calendar.isDateInToday(self)
    }
    
    /// SwifterSwift: Check if date is within yesterday.
    ///
    ///     Date().isInYesterday -> false
    ///
    var isInYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }

    /// SwifterSwift: Check if date is within tomorrow.
    ///
    ///     Date().isInTomorrow -> false
    ///
    var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(self)
    }

    /// SwifterSwift: Check if date is within a weekend period.
    var isInWeekend: Bool {
        return calendar.isDateInWeekend(self)
    }

    /// SwifterSwift: Check if date is within a weekday period.
    var isWorkday: Bool {
        return !calendar.isDateInWeekend(self)
    }

    /// SwifterSwift: Check if date is within the current week.
    var isInCurrentWeek: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// SwifterSwift: Check if date is within the current month.
    var isInCurrentMonth: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    /// SwifterSwift: Check if date is within the current year.
    var isInCurrentYear: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    var isInCurrentFuture : Bool {
        return isInToday || isInFuture
    }
    
    func getDayTimeType() -> String{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        switch hour {
        case 6..<12 :
            return "Morning"
        case 12 :
            return "Noon"
        case 13..<17 :
            return "Afternoon"
        case 17..<22 :
            return "Evening"
        default:
            return "Night"
        }
    }
}

extension String {
    
    func toDate(_ format:String = "yyyy/MM/dd HH:mm:ss")-> Date?{
          let dateFormatter = DateFormatter()
          //  dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
          dateFormatter.dateFormat = format
          let date = dateFormatter.date(from: self)
          return date
      }
    
    func fromParserDateToDisplayDate() -> String {
        if let date = self.toDate(DateFormatsList.Parser_Date) {
            return date.toString(DateFormatsList.Display_Date)
        }else{
            return self
        }
    }
    
    func fromParserDateToDate() -> Date? {
       return self.toDate(DateFormatsList.Parser_Date)
    }
}
