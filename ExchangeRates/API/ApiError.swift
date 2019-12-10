//
//  ApiError.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 09.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

public enum ApiError: Error {
    case invalidEndpoint
    case noDataAvailable
    case decodeError
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidEndpoint:
            return NSLocalizedString("The download request did not succeed.", comment: "Error")
        case .noDataAvailable:
            return NSLocalizedString("The download request returned nil response.", comment: "Error")
        case .decodeError:
            return NSLocalizedString("The downloaded data are corrupted and can not be read.", comment: "Error")
        }
    }
}
