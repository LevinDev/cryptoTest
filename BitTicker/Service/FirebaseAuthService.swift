//
//  FirebaseAuthManager.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/3/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//


import FirebaseAuth
import UIKit
import Combine

class FirebaseAuthService {

    func createUser(email: String, password: String) -> Future<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                if let networkError = error  {
                    promise(.failure(networkError))
                } else if let user = authResult?.user {
                    promise(.success(user))
                }
            }
        }
    }
    
    func newcreateUser(email: String, password: String) -> Future<Result<User,Error>, Never> {
        return Future<Result<User,Error>, Never> { promise in
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                if let networkError = error  {
                    promise(.success(.failure(networkError)))
                } else if let user = authResult?.user {
                    promise(.success(.success(user)))
                }
            }
        }
    }
    
    func newsignIn(email: String, pass: String) -> Future<Result<User,Error>, Never> {
        return Future<Result<User,Error>, Never> { promise in
            Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
                if let networkError = error  {
                    promise(.success(.failure(networkError)))
                } else if let user = result?.user {
                    promise(.success(.success(user)))
                }
            }
        }
    }
}
