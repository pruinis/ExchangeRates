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
    var exchangeRate: ExchangeRate?
    
    func fetchLatestExchangeRateUSD(completion: @escaping () -> Void) {        
        apiClient.fetchLatestExchangeRateUSD { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let exchangeRate):
                        self?.exchangeRate = exchangeRate
                    case .failure:
                        self?.exchangeRate = nil
                }
                completion()
            }
        }
    }
}
