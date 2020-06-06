//
//  BTSignUpVC.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/2/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import UIKit
import Combine

class BTSignUpVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldEmail: UITextField?
    @IBOutlet weak var textFieldPassword: UITextField?
    @IBOutlet weak var buttonSignUp: UIButton?
    @IBOutlet weak var buttonCancel: UIButton?
    
    var disposibles = Set<AnyCancellable>()
    private let viewModel: SignUpViewModelType
    var bindings = Set<AnyCancellable>()
    var input = SignUpViewModelInput()
    
    // MARK: - Initializer
    init?(coder: NSCoder, viewModel: SignUpViewModelType) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        inputBindings()
        outputBinding()
    }
    
    func inputBindings() {
        input.createPressed = buttonSignUp?.publisher.eraseToAnyPublisher()
        input.cancelPressed = buttonCancel?.publisher.eraseToAnyPublisher()
        
        textFieldEmail?.valueChangedPublisher
            .assign(to: \SignUpViewModelInput.email, on: input)
            .store(in: &bindings)
        
        textFieldPassword?.valueChangedPublisher
            .assign(to: \SignUpViewModelInput.password, on: input)
            .store(in: &bindings)
    }
    
    func outputBinding() {
        viewModel.transform(input: input)
            .receive(on: DispatchQueue.main)
             .sink(receiveValue: { [unowned self](state) in
                           switch state {
                           case .loading:
                               self.showHud(message: "Loading")
                           case .validation(let value):
                               self.buttonSignUp?.isEnabled = value
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
