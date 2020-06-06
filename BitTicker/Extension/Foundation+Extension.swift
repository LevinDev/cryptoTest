//
//  Foundation+Extension.swift
//  BitTicker
//
//  Created by Levin varghese on 06/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}

extension Array {
    func item(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element == TickerData {
    mutating func update(_ value: Element) -> [Element]? {
        if self.contains(value) {
            let index = self.firstIndex(of: value)
            self.remove(at: index!)
            self.insert(value, at: index!)
            return self
        }
        return nil
    }
}
