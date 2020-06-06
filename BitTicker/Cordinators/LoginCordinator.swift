//
//  LoginCordinator.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import UIKit

class LoginCordinator: FlowCoordinator {
    fileprivate let rootController: UINavigationController
    fileprivate let dependencyProvider: LoginCoordinatorDependencyProvider
    
    init(rootController: UINavigationController, dependencyProvider: LoginCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let searchController = self.dependencyProvider.loginController(navigator: self)
        self.rootController.setViewControllers([searchController], animated: false)
    }
}

extension LoginCordinator: LoginNavigator {
    
    func showHomeVc() {
        let homeController = self.dependencyProvider.HomeController(navigator: self)
        self.rootController.pushViewController(homeController, animated: true)
    }
    
    func showSignUpVc() {
        let signUpController = self.dependencyProvider.signUpController(navigator: self)
        self.rootController.pushViewController(signUpController, animated: true)
    }
    
    func goBackToLogin() {
        self.rootController.popViewController(animated: true)
      }
    
    func goToDetail(_ ticker: TickerData) {
        let detailController = self.dependencyProvider.detailController(data: ticker, navigator: self)
        self.rootController.pushViewController(detailController, animated: true)
    }
    
    
    
    
}
