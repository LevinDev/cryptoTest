//
//  TickerUseCase.swift
//  BitTicker
//
//  Created by Levin varghese on 06/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth

protocol TickerUserCasetype {
    func subscribeTicker() -> AnyPublisher<TickerData, Error>
}

final class TickerUserCase: TickerUserCasetype {
   
    private let network: NetworkService<TickerData>
    
    init(network: NetworkService<TickerData>) {
        self.network = network
    }
    
    func subscribeTicker() -> AnyPublisher<TickerData, Error> {
        let requestData = SubsriptionRequestData(command: "subscribe", channel: "1002")
        let request = PolinexRequest.tickerData(subscriptionRequest: requestData)
        let publisher: AnyPublisher<TickerData, Error> = self.network.load(request: request)
            .dropFirst()
            .throttle(for: 0.01, scheduler: DispatchQueue.global(), latest: true)
            .removeDuplicates()
            .eraseToAnyPublisher()
        return publisher
    }
    
}
