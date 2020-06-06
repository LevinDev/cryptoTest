//
//  NetworkService.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/3/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import Combine

final class NetworkService<ResultType: Codable>: NetworkServiceType {
    typealias NetworkResult = PassthroughSubject<ResultType, Error>
    private let session: URLSession
    private let resultPublisher: PassthroughSubject<ResultType, Error>

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral), result: NetworkResult) {
        self.session = session
        self.resultPublisher = result
    }

     func load<ResultType, Request>(request: Request) -> AnyPublisher<ResultType, Error> where ResultType : Decodable, Request : NetworkRequest {
        let websocket = self.session.webSocketTask(with: request.url)
        websocket.resume()
        let encoder = JSONEncoder()
        let data = try? encoder.encode(request.requestData)
        let message = URLSessionWebSocketTask.Message.data(data!)
        websocket.send(message) { (subscriptionError) in
            if let error = subscriptionError {
                self.resultPublisher.send(completion: Subscribers.Completion.failure(error))
            }
        }
        return self.setReceiveHandler(websocketTask: websocket).eraseToAnyPublisher() as! AnyPublisher<ResultType, Error>
       }

    func setReceiveHandler(websocketTask: URLSessionWebSocketTask) -> NetworkResult {
        websocketTask.receive { [weak self] result in
            defer { _ = self?.setReceiveHandler(websocketTask: websocketTask) }

               do {
                 let message = try result.get()
                 switch message {
                 case let .string(string):
                 //  print(string)
                   if let ticker =  TickerData(data: string) {
                      // print(ticker)
                       self?.resultPublisher.send(ticker as! ResultType)
                   }
                 case let .data(data):
                   print(data)
                 @unknown default:
                   print("unkown message received")
                 }
               } catch {
                 // handle the error
                 self?.resultPublisher.send(completion: Subscribers.Completion.failure(error))
                 print(error)
               }
             }
           return self.resultPublisher
    }
}
