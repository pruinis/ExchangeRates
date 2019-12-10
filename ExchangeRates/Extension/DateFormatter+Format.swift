//
//  DateFormatter+Format.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 09.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

extension DateFormatter {
  
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Date {
    
    func stringDate(fromDate: Date = Date()) -> String {
        let formatter = DateFormatter.yyyyMMdd
        return formatter.string(from: self)
    }
    
    func getPreviousWeekDateString(fromDate: Date = Date()) -> String {
        guard let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: fromDate) else {
            return Date().stringDate()
        }
        return lastWeekDate.stringDate()
    }
}

