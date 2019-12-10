//
//  DefaultsManager.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 11.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit

struct DefaultsManager {

    static let userSessionKey = "com.save.usersession"
    private static let userDefault = UserDefaults.standard
    
    static func saveDate(){
        userDefault.set(Date(), forKey: userSessionKey)
    }
    
    static func getDate() -> Date? {
        return userDefault.object(forKey: userSessionKey) as? Date
    }
    
    static func getIntervalSince(date: Date) -> TimeInterval? {
        guard let savedDate = getDate() else { return nil }
        return date.timeIntervalSince(savedDate)
    }
}
