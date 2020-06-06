//
//  ApplicationCordinator.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import UIKit

class ApplicationFlowCoordinator: FlowCoordinator {
    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider & LoginCoordinatorDependencyProvider
    
    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()
    
    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let loginController = UINavigationController()
        loginController.isNavigationBarHidden = true
        self.window.rootViewController = loginController
        let loginCordinator = LoginCordinator(rootController: loginController, dependencyProvider: dependencyProvider)
        loginCordinator.start()
        childCoordinators = [loginCordinator]
    }
}
