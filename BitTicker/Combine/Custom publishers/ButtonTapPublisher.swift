//
//  ButtonPublisher.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation

import Foundation
import Combine
import UIKit

extension UIButton {
    var publisher: Publishers.ButtonTapPublisher {
        return Publishers.ButtonTapPublisher(button: self)
    }
}

extension Publishers {
    struct ButtonTapPublisher: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        private let button: UIButton
        
        init(button: UIButton) { self.button = button }
        
        func receive<S>(subscriber: S) where S : Subscriber, Publishers.ButtonTapPublisher.Failure == S.Failure, Publishers.ButtonTapPublisher.Output == S.Input {
            let subscription = ButtonSubscription(subscriber: subscriber, button: button)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class ButtonSubscription<S: Subscriber>: Subscription where S.Input == Void, S.Failure == Never {
        
        private var subscriber: S?
        private weak var button: UIButton?
        
        init(subscriber: S, button: UIButton) {
            self.subscriber = subscriber
            self.button = button
            subscribe()
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
            button = nil
        }
        
        private func subscribe() {
            button?.addTarget(self,
                              action: #selector(tap(_:)),
                              for: .touchUpInside)
        }
        
        @objc private func tap(_ sender: UIButton) {
            _ = subscriber?.receive(())
        }
    }
}
