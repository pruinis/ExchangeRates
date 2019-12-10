//
//  HistoryRate.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 10.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

struct HistoryRate: Codable {

    var rates = [Rate]()    
    var base = "USD"
    var startAt = Date()
    var endAt = Date()
}

extension HistoryRate {
    
    enum CodingKeys: String, CodingKey {
        case startAt = "start_at"
        case endAt = "end_at"
        case base
        case rates
    }
  
    init(from decoder: Decoder) throws {
            
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.base = try container.decode(String.self, forKey: .base)
            
            let formatter = DateFormatter.yyyyMMdd
            
            // Rates
            let ratesDict = try container.decode([String: [String: Float]].self, forKey: .rates)
            for key in ratesDict.keys {                
                if let exchangeRateDict = ratesDict[key] {
                    if let name = exchangeRateDict.keys.first, let rate = exchangeRateDict[name] {
                        var rate = Rate(currencyName: name, exchangeRate: rate)
                        
                        if let date = formatter.date(from: key) {
                            rate.date = date
                        }
                        
                        self.rates.append(rate)
                    }
                }
            }

            // Dates
            let startAtString = try container.decode(String.self, forKey: .startAt)
            if let date = formatter.date(from: startAtString) {
                self.startAt = date
            }
            
            let endAtString = try container.decode(String.self, forKey: .endAt)
            if let date = formatter.date(from: endAtString) {
                self.endAt = date
            }
            
        } catch {
            print(error)
        }
    }
    
}
