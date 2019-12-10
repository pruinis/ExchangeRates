//
//  Translator.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 11.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import RealmSwift

protocol Translator {
    
    associatedtype T
    associatedtype RealmT

    func toObject(with any: T) -> RealmT
    func toAny(with object: RealmT) -> T
}

final class RateTranslator: Translator {
    
    typealias T = Rate
    typealias RealmT = RealmRate

    func toObject(with any: Rate) -> RealmRate {
        let object = RealmRate()
        object.currencyName = any.currencyName
        object.exchangeRate = any.exchangeRate
        object.date = any.date
        return object
    }
    
    func toAny(with object: RealmRate) -> Rate {        
        return Rate(currencyName: object.currencyName,
                    exchangeRate: object.exchangeRate,
                    date: object.date)
    }
}
