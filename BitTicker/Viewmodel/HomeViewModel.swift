//
//  HomeViewModel.swift
//  BitTicker
//
//  Created by Levin varghese on 06/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import Combine

enum HomeState {
    case loading
    case subscriptionData(TickerData)
    case failure(Error)
}

class HomeViewModelInput {
    /// called when the user action is performed
    var viewLoaded: AnyPublisher<Void, Never>? = nil
    var userSelection: AnyPublisher<TickerData, Never>? = nil
}

typealias HomeViewModelOutput = AnyPublisher <HomeState, Never>

protocol HomeViewModelType {
    func transform(input: HomeViewModelInput) -> HomeViewModelOutput
}

final class HomeViewModel: HomeViewModelType {
    
    let useCase: TickerUserCasetype
    private let navigator: LoginNavigator
    private var cancellables: [AnyCancellable] = []
    
    init(useCase: TickerUserCasetype, navigator: LoginNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: HomeViewModelInput) -> HomeViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.userSelection?
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[unowned self] in self.navigator.goToDetail($0)})
            .store(in: &cancellables)
            
        
        let showLoading = input.viewLoaded!.flatMap({ (Void) -> HomeViewModelOutput in
            let pub: HomeViewModelOutput = .just(HomeState.loading)
            return pub
        }).receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        let subscrptionResult = input.viewLoaded!.flatMapLatest { (Void) -> HomeViewModelOutput in
            return self.useCase.subscribeTicker()
                .map({HomeState.subscriptionData($0)})
                .catch {Just(HomeState.failure($0)).eraseToAnyPublisher()}
                .eraseToAnyPublisher()
        }
        return Publishers.Merge(showLoading, subscrptionResult).eraseToAnyPublisher()
    }
    
}
