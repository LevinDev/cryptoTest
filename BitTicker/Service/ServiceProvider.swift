//
//  ServiceProvider.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import Combine

class ServicesProvider {
    let network: NetworkServiceType
    let auth: FirebaseAuthService

    static func defaultProvider() -> ServicesProvider {
        let network = NetworkService<TickerData>(result: PassthroughSubject<TickerData, Error>())
        let auth = FirebaseAuthService()
        return ServicesProvider(network: network, auth: auth)
    }

    init(network: NetworkServiceType, auth: FirebaseAuthService) {
        self.network = network
        self.auth = auth
    }
}
