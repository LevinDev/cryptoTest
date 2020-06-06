//
//  ApplicationComponentsFactory.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class ApplicationComponentsFactory {
    fileprivate lazy var useCase = UserUseCase(authService: FirebaseAuthService())
    fileprivate lazy var useCaseHome = TickerUserCase(network: NetworkService(result: PassthroughSubject<TickerData, Error>()))
    
    private let servicesProvider: ServicesProvider
    
    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {
    func rootViewController() -> UINavigationController {
        let rootViewController = UINavigationController()
        return rootViewController
    }
}

extension ApplicationComponentsFactory: LoginCoordinatorDependencyProvider {
   
    func loginController(navigator: LoginNavigator) -> UIViewController {
        let viewModel = LoginViewModel(useCase: useCase, navigator: navigator)
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Login", creator: { (coder) -> BTSignInVC? in
            return BTSignInVC(coder: coder, viewModel: viewModel)
        })
    }
    
    func signUpController(navigator: LoginNavigator) -> UIViewController {
        let viewModel = SignUpViewModel(useCase: useCase, navigator: navigator)
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BTSignUpVC", creator: { (coder) -> BTSignUpVC? in
            return BTSignUpVC(coder: coder, viewModel: viewModel)
        })
    }
    
    func HomeController(navigator:LoginNavigator) -> UIViewController {
        let viewModel = HomeViewModel(useCase: useCaseHome, navigator: navigator)
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeVC", creator: { (coder) -> HomeVC? in
            return HomeVC(coder: coder, viewModel: viewModel)
        })
    }
    
    func detailController(data: TickerData, navigator: LoginNavigator) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailVc", creator: { (coder) -> DetailVc? in
                   return DetailVc(coder: coder, tickerData: data)
               })
    }
    
}
