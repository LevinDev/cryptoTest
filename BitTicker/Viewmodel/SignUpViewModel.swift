//
//  SignUpViewModel.swift
//  BitTicker
//
//  Created by Levin varghese on 06/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

enum SignUpState {
    case loading
    case validation(Bool)
    case success(User)
    case failure(Error)
}

class SignUpViewModelInput {
    /// triggered when the email is updated
    @Published var email: String = ""
    // triggered when the password is updated
    @Published var password: String = ""
     /// called when the user action is performed
    var createPressed: AnyPublisher<Void, Never>? = nil
    var cancelPressed: AnyPublisher<Void, Never>? = nil
    
}

typealias SignUpViewModelOutput = AnyPublisher <SignUpState, Never>

protocol SignUpViewModelType {
    func transform(input: SignUpViewModelInput) -> SignUpViewModelOutput
}

final class SignUpViewModel: SignUpViewModelType {
    
    private let useCase: UserUseCaseType
    private let navigator: LoginNavigator
    private var cancellables: [AnyCancellable] = []
    
    init(useCase: UserUseCaseType, navigator: LoginNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: SignUpViewModelInput) -> SignUpViewModelOutput {
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
        
        var validation: SignUpViewModelOutput {
           Publishers.CombineLatest(conditionOne(), conditionTwo()).map { (arf) -> SignUpState in
            return SignUpState.validation((arf.0 && arf.1))
            }.eraseToAnyPublisher()
        }
        
        input.cancelPressed?.receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] in self?.navigator.goBackToLogin()}).store(in: &cancellables)
        
        let showLoading = input.createPressed!.flatMap({ (Void) -> SignUpViewModelOutput in
            let pub: SignUpViewModelOutput = .just(SignUpState.loading)
            return pub
            }).eraseToAnyPublisher()
        
        let user = input.createPressed!.flatMapLatest({[unowned self] _ in self.useCase.signUp(with: input.email, password: input.password) })
            .map { result -> SignUpState in
                switch result {
                case .success(let user):
                    self.navigator.showHomeVc()
                    return SignUpState.success(user)
                case .failure(let error): return SignUpState.failure(error)
                }
        }.eraseToAnyPublisher()
        
        let userLogin = Publishers.Merge(showLoading, user)
        return Publishers.Merge(validation, userLogin).eraseToAnyPublisher()
    }
    
    
    
}
