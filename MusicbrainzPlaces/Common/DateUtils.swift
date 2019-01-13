//
//  DateUtils.swift
//  MusicbrainzPlaces
//
//  Created by Gediminas Urbonas on 11/12/2018.
//  Copyright © 2018 Gediminas Urbonas. All rights reserved.
//

import UIKit

/// This class provide utility methods for date parsing and formatting.
public class DateUtils {
    
    let format1 = DateFormatter()
    
    let format2 = DateFormatter()
    
    let format3 = DateFormatter()

    
    /// Shared singleton object of DateUtils.
    public static let sharedUtils = DateUtils()
    
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    
    // MARK: Date parsing
    
    /**
     Convenience method that passes the call to sharedUtils object.
     */
    public class func date(from dateString: String) -> Date? {
        return sharedUtils.date(from: dateString)
    }
    
    /**
     Parses date from string with provided format.
     
     - parameter dateString: A string containing the date.
     - parameter format: The format of the date.
     
     - returns: A NSDate object if date was parsed successfully, otherwise nil.
     */
    public func date(from dateString: String) -> Date? {
        format1.dateFormat = "yyyy"
        format2.dateFormat = "yyyy-MM-dd"
        format3.dateFormat = "yyyy-MM"

        let parsers = [format1, format2, format3]
        
        for parser in parsers {
            if let result = parser.date(from: dateString) {
                return result
            }
        }
        
        return nil
    }
    
    
    // MARK: Date formatting.
    
    /**
     Convenience method that passes the call to sharedUtils object.
     */
    public class func string(from date: Date, format: String) -> String? {
        return sharedUtils.string(from: date, format: format)
    }
    
    /**
     Constructs a textual representation of the date.
     
     - parameter date: A date to foramt.
     - parameter format: The format in which the date should be represented.
     
     - returns: A string containing textual representation of the date.
     */
    public func string(from date: Date, format: String) -> String? {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
