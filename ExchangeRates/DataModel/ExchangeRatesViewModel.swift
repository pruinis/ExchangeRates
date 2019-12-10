//
//  ExchangeRatesViewModel.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 10.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

class ExchangeRatesViewModel {
    
    let apiClient = ApiClient()
    var rates = [Rate]()
    private var realmManager = RealmManager()
    private let requestInterval = 600.0 // 10 min
    
    func showExchangeRateUSD(completion: @escaping () -> Void) {
                
        guard let prevRequestInterval  = DefaultsManager.getIntervalSince(date: Date()) else {
            fetchServerLatestExchangeRateUSD(completion: completion)
            return
        }
        
        if prevRequestInterval >= requestInterval {
            fetchServerLatestExchangeRateUSD(completion: completion)
        }
        else {
            fetchRealmRates(completion: completion)
        }
    }
    
    private func fetchServerLatestExchangeRateUSD(completion: @escaping () -> Void) {
        apiClient.fetchLatestExchangeRateUSD { [weak self] (result) in
            DispatchQueue.main.async {
                self?.rates.removeAll()
                switch result {
                case .success(let exchangeRate):
                    self?.rates.append(contentsOf: exchangeRate.rates)
                    if let rates = self?.rates {
                        self?.realmManager.reloadRates(rates: rates, completion: { })
                    }
                    DefaultsManager.saveDate()
                case .failure: break
                }
                completion()
            }
        }
    }
    
    private func fetchRealmRates(completion: @escaping () -> Void) {
        realmManager.getStoredRates { [weak self] (rates) in
            DispatchQueue.main.async {
                self?.rates.removeAll()
                self?.rates.append(contentsOf: rates)
                completion()
            }
        }
    }
}
