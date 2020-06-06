//
//  BTSignInVC.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/2/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import UIKit
import Combine

class BTSignInVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldEmail: UITextField?
    @IBOutlet weak var textFieldPassword: UITextField?
    @IBOutlet weak var buttonLogin: UIButton?
    @IBOutlet weak var buttonCreateAccount: UIButton?
    @IBOutlet weak var buttonGuest: UIButton?
    
    private let viewModel: LoginViewModelType
    var bindings = Set<AnyCancellable>()
    var input = LoginViewModelInput()
    
    // MARK: - Initializer
    init?(coder: NSCoder, viewModel: LoginViewModelType) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        input.loginPressed = buttonLogin?.publisher.eraseToAnyPublisher()
        input.createAccountPressed = buttonCreateAccount?.publisher.eraseToAnyPublisher()
        input.guestAccountPressed = buttonGuest?.publisher.eraseToAnyPublisher()
        
        textFieldEmail?.valueChangedPublisher
            .assign(to: \LoginViewModelInput.email, on: input)
            .store(in: &bindings)
        
        textFieldPassword?.valueChangedPublisher
            .assign(to: \LoginViewModelInput.password, on: input)
            .store(in: &bindings)
        
        viewModel.transform(input: input)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self](state) in
                switch state {
                case .loading:
                    self.showHud(message: "Loading")
                case .validation(let value):
                    self.buttonLogin?.isEnabled = value
                case .success(let user):
                    self.hideHud()
                    print(user)
                case .failure(let error):
                    self.hideHud()
                    self.presentAlert(withTitle: "Error", message: error.localizedDescription)
                    print(error.localizedDescription)
                }
            }).store(in: &bindings)
    }
}
