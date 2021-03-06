//
//  CurrencyPair.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/3/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import UIKit

struct CurrencyPair {

    let from: String?
    let to: String?

    lazy var fromImage: UIImage? = {
        return UIImage(named: self.from?.lowercased() ?? "")
    }()

    lazy var toImage: UIImage? = {
        return UIImage(named: self.to?.lowercased() ?? "")
    }()

    lazy var displayTitle: String? = {
        return (self.from ?? "") + " <--> " + (self.to ?? "")
    }()



    static func getCurrencyPair(pairdId: Int) -> CurrencyPair {
        let pairs = CurrencyPair.currencyPairs[pairdId]
        let pairsarray = pairs?.components(separatedBy: "_")
        return CurrencyPair(from: pairsarray?.first, to: pairsarray?[1])
    }


    static let currencyPairs = [
        343:    "USDT_MDT",
        338:    "USDT_BUSD",
        337:    "USDT_BNB",
        177:    "BTC_ARDR",
        253:    "BTC_ATOM",
        324:    "BTC_AVA",
        210:    "BTC_BAT",
        189:    "BTC_BCH",
        236:    "BTC_BCHABC",
        238:    "BTC_BCHSV",
        232:    "BTC_BNT",
        14:    "BTC_BTS",
        15:    "BTC_BURST",
        333:    "BTC_CHR",
        194:    "BTC_CVC",
        24:    "BTC_DASH",
        162:    "BTC_DCR",
        27:   "BTC_DOGE",
        201:    "BTC_EOS",
        171:    "BTC_ETC",
        148:    "BTC_ETH",
        266:    "BTC_ETHBNT",
        246:    "BTC_FOAM",
        317:    "BTC_FXC",
        198:    "BTC_GAS",
        185:    "BTC_GNT",
        251:    "BTC_GRIN",
        43:   "BTC_HUC",
        207:    "BTC_KNC",
        275:    "BTC_LINK",
        213:    "BTC_LOOM",
        250:    "BTC_LPT",
        163:    "BTC_LSK",
        50:    "BTC_LTC",
        229:    "BTC_MANA",
        295:    "BTC_MATIC",
        302:    "BTC_MKR",
        309:    "BTC_NEO",
        64:   "BTC_NMC",
        248:    "BTC_NMR",
        69:    "BTC_NXT",
        196:    "BTC_OMG",
        249:   "BTC_POLY",
        75:    "BTC_PPC",
        221:    "BTC_QTUM",
        174:    "BTC_REP",
        170:    "BTC_SBD",
        150:    "BTC_SC",
        204:    "BTC_SNT",
        290:    "BTC_SNX",
        168:    "BTC_STEEM",
        200:   "BTC_STORJ",
        89:    "BTC_STR",
        182:    "BTC_STRAT",
        312:    "BTC_SWFTC",
        92:    "BTC_SYS",
        263:    "BTC_TRX",
        108:    "BTC_XCP",
        112:    "BTC_XEM",
        114:    "BTC_XMR",
        117:    "BTC_XRP",
        277:    "BTC_XTZ",
        178:    "BTC_ZEC",
        192:    "BTC_ZRX",
        306:    "DAI_BTC",
        307:    "DAI_ETH",
        211:    "ETH_BAT",
        190:    "ETH_BCH",
        202:    "ETH_EOS",
        172:    "ETH_ETC",
        176:    "ETH_REP",
        179:    "ETH_ZEC",
        193:    "ETH_ZRX",
        284:    "PAX_BTC",
        285:    "PAX_ETH",
        326:    "TRX_AVA",
        271:    "TRX_BTT",
        335:    "TRX_CHR",
        267:    "TRX_ETH",
        319:    "TRX_FXC",
        316:    "TRX_JST",
        276:    "TRX_LINK",
        297:    "TRX_MATIC",
        311:    "TRX_NEO",
        292:    "TRX_SNX",
        274:    "TRX_STEEM",
        314:    "TRX_SWFTC",
        273:    "TRX_WIN",
        268:    "TRX_XRP",
        279:    "TRX_XTZ",
        254:    "USDC_ATOM",
        235:    "USDC_BCH",
        237:    "USDC_BCHABC",
        239:    "USDC_BCHSV",
        224:    "USDC_BTC",
        256:    "USDC_DASH",
        243:    "USDC_DOGE",
        257:    "USDC_EOS",
        258:    "USDC_ETC",
        225:    "USDC_ETH",
        252:    "USDC_GRIN",
        244:    "USDC_LTC",
        242:    "USDC_STR",
        264:    "USDC_TRX",
        226:    "USDC_USDT",
        241:    "USDC_XMR",
        240:    "USDC_XRP",
        245:    "USDC_ZEC",
        288:    "USDJ_BTC",
        323:    "USDJ_BTT",
        289:    "USDJ_TRX",
        255:    "USDT_ATOM",
        325:    "USDT_AVA",
        212:    "USDT_BAT",
        191:    "USDT_BCH",
        260:    "USDT_BCHABC",
        298:    "USDT_BCHBEAR",
        259:    "USDT_BCHSV",
        299:    "USDT_BCHBULL",
        320:    "USDT_BCN",
        280:    "USDT_BEAR",
        293:    "USDT_BSVBEAR",
        294:    "USDT_BSVBULL",
        121:    "USDT_BTC",
        270:    "USDT_BTT",
        281:    "USDT_BULL",
        304:    "USDT_BVOL",
        334:    "USDT_CHR",
        308:    "USDT_DAI",
        122:    "USDT_DASH",
        262:    "USDT_DGB",
        216:    "USDT_DOGE",
        203:    "USDT_EOS",
        330:    "USDT_EOSBEAR",
        329:    "USDT_EOSBULL",
        173:    "USDT_ETC",
        149:    "USDT_ETH",
        300:    "USDT_ETHBEAR",
        301:    "USDT_ETHBULL",
        318:    "USDT_FXC",
        217:    "USDT_GNT",
        261:    "USDT_GRIN",
        305:    "USDT_IBVOL",
        315:    "USDT_JST",
        322:    "USDT_LINK",
        332:    "USDT_LINKBEAR",
        331:    "USDT_LINKBULL",
        218:    "USDT_LSK",
        123:    "USDT_LTC",
        231:    "USDT_MANA",
        296:    "USDT_MATIC",
        303:    "USDT_MKR",
        310:    "USDT_NEO",
        124:    "USDT_NXT",
        286:    "USDT_PAX",
        223:    "USDT_QTUM",
        175:    "USDT_REP",
        219:    "USDT_SC",
        291:    "USDT_SNX",
        321:    "USDT_STEEM",
        125:    "USDT_STR",
        313:    "USDT_SWFTC",
        265:    "USDT_TRX",
        282:   "USDT_TRXBEAR",
        283:    "USDT_TRXBULL",
        287:    "USDT_USDJ",
        272:    "USDT_WIN",
        126:    "USDT_XMR",
        127:    "USDT_XRP",
        328:    "USDT_XRPBEAR",
        327:    "USDT_XRPBULL",
        278:    "USDT_XTZ",
        180:    "USDT_ZEC",
        220:    "USDT_ZRX",
        336:    "BNB_BTC",
        341:    "BUSD_BTC"
    ]
}
