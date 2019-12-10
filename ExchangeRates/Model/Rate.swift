//
//  Rate.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 10.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

struct Rate: Codable {

    let currencyName: String
    let exchangeRate: Float
    var date = Date()
}
