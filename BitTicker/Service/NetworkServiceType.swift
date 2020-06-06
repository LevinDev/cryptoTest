//
//  NetworkServiceType.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/3/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import Combine

protocol NetworkServiceType: AnyObject {

    @discardableResult
    func load<T:Decodable,Request: NetworkRequest>(request: Request) -> AnyPublisher<T, Error>
}

protocol NetworkRequest {
    associatedtype requestData: Codable
    var url: URL { get }
    var requestData: requestData { get }
}

struct AppConstants {
    static let polinexUrL = "wss://api2.poloniex.com"
}

enum PolinexRequest: NetworkRequest {
    var url: URL {
        return URL(string: AppConstants.polinexUrL)!
    }

    var requestData: SubsriptionRequestData {
        switch self {
        case .tickerData(let SubsriptionRequestData): return SubsriptionRequestData
        }
    }

    case tickerData(subscriptionRequest: SubsriptionRequestData)
}

/// Defines the Network service errors.
enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}
