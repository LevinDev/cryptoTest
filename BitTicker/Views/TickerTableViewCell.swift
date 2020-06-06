//
//  TickerTableViewCell.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/3/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import UIKit

class TickerTableViewCell: UITableViewCell {
     @IBOutlet weak var labelLastPrice: UILabel?
     @IBOutlet weak var labelCurrencyPair: UILabel?
     @IBOutlet weak var imageViewFrom: UIImageView?
     @IBOutlet weak var imageViewTo: UIImageView?
     @IBOutlet weak var imageArrow: UIImageView?

    lazy var upArrow: UIImage? = {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
        return UIImage(systemName: "arrow.up", withConfiguration: config)?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    }()

    lazy var downArrow: UIImage? = {
           let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
           return UIImage(systemName: "arrow.down", withConfiguration: config)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
       }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(ticker: TickerData, userInputValue: String?) {
        labelLastPrice?.text = ticker.lastTradePrice
        var currencyPair = CurrencyPair.getCurrencyPair(pairdId: ticker.currencyPair)
        labelCurrencyPair?.text = currencyPair.displayTitle
        imageViewFrom?.image = currencyPair.fromImage
        imageViewTo?.image = currencyPair.toImage
        
        if let doubleValue = Double(userInputValue ?? ""), let lastPrice = Double(ticker.lastTradePrice) {
            imageArrow?.isHidden = false
            imageArrow?.image = lastPrice > doubleValue ? upArrow : downArrow
        }
        imageArrow?.isHidden = (userInputValue?.isEmpty ?? false) ? true : false
    }

}
