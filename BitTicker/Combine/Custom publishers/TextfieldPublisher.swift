//
//  TextfieldPublisher.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/4/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import Combine
import UIKit

extension UITextField {
    var valueChangedPublisher: Publishers.TextfieldChangePublisher {
        Publishers.TextfieldChangePublisher(textField: self)
    }

    var didChangePublisher: NotificationCenter.Publisher {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
    }
}

extension Publishers {

    struct TextfieldChangePublisher: Publisher{


        typealias Output = String
        typealias Failure = Never

        private let textField: UITextField

        init(textField: UITextField) { self.textField = textField }

        func receive<S>(subscriber: S) where S : Subscriber, Publishers.TextfieldChangePublisher.Failure == S.Failure, Publishers.TextfieldChangePublisher.Output == S.Input {
            let subscription = TextFieldChangeSubscription(subscriber: subscriber, textField: textField)
            subscriber.receive(subscription: subscription)
        }
    }

    class TextFieldChangeSubscription<S: Subscriber>: Subscription where S.Input == String, S.Failure == Never {
        func request(_ demand: Subscribers.Demand) {
            
        }

        func cancel() {
            self.subscriber = nil
            self.textfield = nil
        }

        private var subscriber: S?
        private weak var textfield: UITextField?

        init(subscriber: S, textField: UITextField) {
            self.subscriber = subscriber
            self.textfield = textField
            subscribe()
        }

        private func subscribe() {
            textfield?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }

        @objc private func textFieldDidChange(_ textField: UITextField) {
            _ = subscriber?.receive(textField.text ?? "")
        }
    }
}
