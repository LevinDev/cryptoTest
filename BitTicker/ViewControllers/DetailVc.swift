//
//  DetailVc.swift
//  BitTicker
//
//  Created by Levin varghese on 06/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import UIKit

class DetailVc: UIViewController {
    
    @IBOutlet weak var lastTradePrice: UILabel?
    @IBOutlet weak var lowestAsk: UILabel?
    @IBOutlet weak var highestBid: UILabel?
    @IBOutlet weak var percentageChange: UILabel?
    @IBOutlet weak var baseCurrencyVolume: UILabel?
    @IBOutlet weak var quoteCurrencyVolume: UILabel?
    @IBOutlet weak var isFrozen:UILabel?
    @IBOutlet weak var highestTradingPrice: UILabel?
    @IBOutlet weak var lowestTradePrice: UILabel?
    @IBOutlet weak var labelCurrencyPair: UILabel?
    @IBOutlet weak var imageViewFrom: UIImageView?
    @IBOutlet weak var imageViewTo: UIImageView?
    
    let tickerData: TickerData
    // MARK: - Initializer
    init?(coder: NSCoder, tickerData: TickerData) {
        self.tickerData = tickerData
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func bindUI() {
        self.lastTradePrice?.text = "lastTradePrice : \(tickerData.lastTradePrice)"
        self.lowestAsk?.text = "lowestAsk : \(tickerData.lowestAsk)"
        self.highestBid?.text = "highestBid :\(tickerData.highestBid)"
        self.percentageChange?.text = "percentageChange : %\(tickerData.percentageChange)"
        self.baseCurrencyVolume?.text = "baseCurrencyVolume :\(tickerData.baseCurrencyVolume)"
        self.quoteCurrencyVolume?.text = "quoteCurrencyVolume :\(tickerData.baseCurrencyVolume)"
        self.highestTradingPrice?.text = "highestTradingPrice : \(tickerData.highestTradingPrice)"
        self.lowestTradePrice?.text = "lowestTradePrice : \(tickerData.lowestTradePrice)"
        
        var currencyPair = CurrencyPair.getCurrencyPair(pairdId: tickerData.currencyPair)
        labelCurrencyPair?.text = currencyPair.displayTitle
        imageViewFrom?.image = currencyPair.fromImage
        imageViewTo?.image = currencyPair.toImage
    }
}
