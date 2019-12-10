//
//  RealmRate.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 11.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import RealmSwift

class RealmRate: Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var currencyName: String = ""
    @objc dynamic var exchangeRate: Float = 0
    @objc dynamic var date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
