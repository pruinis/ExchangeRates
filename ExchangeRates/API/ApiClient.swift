//
//  ApiClient.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 09.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit

typealias ExchangeRateResult = (Result<ExchangeRate, Error>)
typealias HistoryRateResult = (Result<HistoryRate, Error>)

public enum ApiKey: String {
    case USD
    case base
    case latest
    case history
    case startAt = "start_at"
    case endAt = "end_at"
    case symbols
}

class ApiClient {
    
    private let baseURL = "https://api.exchangeratesapi.io"
    private let session = URLSession(configuration: .default)
    
    private func fetch(url:URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> Void {
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                result(.failure(ApiError.noDataAvailable))
                return
            }
            result(.success((response, data)))
        }
        task.resume()
    }    
    
    func fetchLatestExchangeRateUSD(completion: @escaping (ExchangeRateResult) -> Void) {
        
        guard let latestURL = URL(string: baseURL)?.appendingPathComponent(ApiKey.latest.rawValue) else {
            completion(.failure(ApiError.invalidEndpoint))
            return
        }
        
        guard var urlComponents = URLComponents(url: latestURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(ApiError.invalidEndpoint))
            return
        }
        
        let queryItems = [URLQueryItem(name: ApiKey.base.rawValue, value: ApiKey.USD.rawValue)]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(ApiError.invalidEndpoint))
            return
        }
        
        fetch(url: url) { (result) in
            
            switch result {
                
            case .success( _, let data):
                    do {
                        let exchangeRate = try JSONDecoder().decode(ExchangeRate.self, from: data)
                        completion(.success(exchangeRate))
                    }
                    catch {
                        completion(.failure(ApiError.decodeError))
                    }                    
                break
                
                case .failure(let error):
                    completion(.failure(error))
                break
            }
        }
    }
    
    func fetchLastWeekHistoryUSD(symbols: String, completion: @escaping (HistoryRateResult) -> Void) {
        
        guard let latestURL = URL(string: baseURL)?.appendingPathComponent(ApiKey.history.rawValue) else {
            completion(.failure(ApiError.invalidEndpoint))
            return
        }
        
        guard var urlComponents = URLComponents(url: latestURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(ApiError.invalidEndpoint))
            return
        }
        
        let currentDate = Date()
        let currentDateString = currentDate.stringDate()
        let lastWeekDateString = currentDate.getPreviousWeekDateString()
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: ApiKey.startAt.rawValue, value: lastWeekDateString),
            URLQueryItem(name: ApiKey.endAt.rawValue, value: currentDateString),
            URLQueryItem(name: ApiKey.base.rawValue, value: ApiKey.USD.rawValue),
            URLQueryItem(name: ApiKey.symbols.rawValue, value: symbols)
        ]
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(ApiError.invalidEndpoint))
            return
        }
                
        fetch(url: url) { (result) in
            
            switch result {
                
            case .success( _, let data):
                    do {
                        let historyRate = try JSONDecoder().decode(HistoryRate.self, from: data)
                        completion(.success(historyRate))
                    }
                    catch {
                        completion(.failure(ApiError.decodeError))
                    }
                break
                
                case .failure(let error):
                    completion(.failure(error))
                break
            }
        }
    }
}
