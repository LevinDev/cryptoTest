//
//  TickerData.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation

struct TickerData: Codable,Hashable {
    var currencyPair: Int = 0
    var lastTradePrice: String  = ""
    var lowestAsk: String = ""
    var highestBid: String = ""
    var percentageChange: String = ""
    var baseCurrencyVolume: String = ""
    var quoteCurrencyVolume: String = ""
    var isFrozen:Bool = false
    var highestTradingPrice: String = ""
    var lowestTradePrice: String = ""

    func hash(into hasher: inout Hasher) {
    return hasher.combine(currencyPair)
    }
    static func == (lhs: TickerData, rhs: TickerData) -> Bool {
    return lhs.currencyPair == rhs.currencyPair
    }

    init?(data: String) {
        if let data = data.data(using: .utf8) , let  array =  try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [Any], let tickerArray = array.item(at: 2) as? [Any] {
            for (index, item) in tickerArray.enumerated()  {
                switch index{
                case 0: self.currencyPair = item as? Int ?? 0
                case 1: self.lastTradePrice = item as? String ?? ""
                case 2: self.lowestAsk = item as? String ?? ""
                case 3: self.highestBid = item as? String ?? ""
                case 4: self.percentageChange = item as? String ?? ""
                case 5: self.baseCurrencyVolume = item as? String ?? ""
                case 6: self.quoteCurrencyVolume = item as? String ?? ""
                case 7: self.isFrozen = item as? Bool ?? false
                case 8: self.highestTradingPrice = item as? String ?? ""
                case 9: self.lowestTradePrice = item as? String ?? ""
                default : break
                }
            }
      }
    }
}
