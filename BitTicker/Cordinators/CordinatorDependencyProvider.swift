//
//  CordinatorDependencyProvider.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationFlowCoordinatorDependencyProvider: class {
    func rootViewController() -> UINavigationController
}

protocol LoginCoordinatorDependencyProvider: class {
    func loginController(navigator: LoginNavigator) -> UIViewController
    func signUpController(navigator:LoginNavigator) -> UIViewController
    func HomeController(navigator:LoginNavigator) -> UIViewController
    func detailController(data: TickerData, navigator:LoginNavigator) -> UIViewController
}
