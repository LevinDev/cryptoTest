//
//  UserUseCase.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth

protocol UserUseCaseType {
    
    func login(with userName: String, password: String) -> AnyPublisher<Result<User,Error>, Never>
    
    func signUp(with userName: String, password: String) -> AnyPublisher<Result<User,Error>, Never>
    
}

final class UserUseCase: UserUseCaseType {
    private let authService: FirebaseAuthService
    
    init(authService: FirebaseAuthService) {
        self.authService = authService
    }
    
    func login(with userName: String, password: String) -> AnyPublisher<Result<User,Error>, Never> {
        return authService.newsignIn(email: userName, pass: password).eraseToAnyPublisher()
    }
    
    func signUp(with userName: String, password: String) -> AnyPublisher<Result<User,Error>, Never> {
        return authService.newcreateUser(email: userName, password: password).eraseToAnyPublisher()
}
    
    
}
