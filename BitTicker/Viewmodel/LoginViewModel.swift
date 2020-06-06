//
//  LoginViewModel.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth

enum LoginState {
    case loading
    case validation(Bool)
    case success(User)
    case failure(Error)
}

class LoginViewModelInput {
    /// triggered when the email is updated
   @Published var email: String = ""
    // triggered when the password is updated
   @Published var password: String = ""
    /// called when the user action is performed
    var loginPressed: AnyPublisher<Void, Never>? = nil
    var createAccountPressed: AnyPublisher<Void, Never>? = nil
    var guestAccountPressed: AnyPublisher<Void, Never>? = nil
    
}

protocol LoginNavigator {
    func showHomeVc()
    func showSignUpVc()
    func goBackToLogin()
    func goToDetail(_ ticker: TickerData)
}

typealias LoginViewModelOutput = AnyPublisher <LoginState, Never>

protocol LoginViewModelType {
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput
}

final class LoginViewModel:LoginViewModelType {
    
    private let useCase: UserUseCaseType
    private let navigator: LoginNavigator
    private var cancellables: [AnyCancellable] = []
    
    
    init(useCase: UserUseCaseType, navigator: LoginNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        func conditionOne() -> AnyPublisher <Bool, Never> {
            let inp = input
            return inp.$email
            .map { (value) -> Bool in
                value.count > 0 ? true : false
            }.eraseToAnyPublisher()
        }
        
        func conditionTwo() -> AnyPublisher <Bool, Never> {
            let inp = input
            return inp.$password
            .map { (value) -> Bool in
                value.count > 4 ? true : false
            }.eraseToAnyPublisher()
        }
        
        var validation: LoginViewModelOutput {
           Publishers.CombineLatest(conditionOne(), conditionTwo()).map { (arf) -> LoginState in
            return LoginState.validation((arf.0 && arf.1))
            }.eraseToAnyPublisher()
        }
        
        input.guestAccountPressed?.receive(on: DispatchQueue.main)
        .sink(receiveValue: {[weak self] in self?.navigator.showHomeVc()}).store(in: &cancellables)
        
        input.createAccountPressed?.receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] in self?.navigator.showSignUpVc()}).store(in: &cancellables)
        
        let showLoading = input.loginPressed!.flatMap({ (Void) -> LoginViewModelOutput in
            let pub: LoginViewModelOutput = .just(LoginState.loading)
            return pub
            }).eraseToAnyPublisher()
        
        let user = input.loginPressed!.flatMapLatest({[unowned self] _ in self.useCase.login(with: input.email, password: input.password) })
            .map { result -> LoginState in
                switch result {
                case .success(let user):
                    self.navigator.showHomeVc()
                    return LoginState.success(user)
                case .failure(let error): return LoginState.failure(error)
                }
        }.eraseToAnyPublisher()
        
        let userLogin = Publishers.Merge(showLoading, user)
        return Publishers.Merge(validation, userLogin).eraseToAnyPublisher()
        }
}

