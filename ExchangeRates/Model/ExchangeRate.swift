//
//  ExchangeRate.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 09.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

struct ExchangeRate : Codable {
    
    var base: String?
    var date: Date?
    var rates = [Rate]()
}

extension ExchangeRate {    
  
    init(from decoder: Decoder) throws {
        
        do {            
            let container = try decoder.container(keyedBy: CodingKeys.self)
              base = try container.decode(String.self, forKey: .base)

              // Rates
              let ratesDict = try container.decode([String: Float].self, forKey: .rates)
              for key in ratesDict.keys {
                  if let exchangeRate = ratesDict[key] {
                      let rate = Rate(currencyName: key, exchangeRate: exchangeRate)
                      rates.append(rate)
                  }
              }

              // Date
              let dateString = try container.decode(String.self, forKey: .date)
              let formatter = DateFormatter.yyyyMMdd
             
              if let date = formatter.date(from: dateString) {
                  self.date = date
              }
            
        } catch {
            print(error)
        }
    }
}
