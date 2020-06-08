//
//  Util.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class FontColorUtility {

    static func fontColorBasedOnSymbolChange(change value: String) -> UIColor {
        let changeValue = Float(value) ?? TTStockMarketConstants.SymbolChangeLimit
        switch changeValue {
        case _ where changeValue < TTStockMarketConstants.SymbolChangeLimit:
            return TTStockMarketConstants.RedColor ?? .red
        case _ where changeValue > TTStockMarketConstants.SymbolChangeLimit:
            return TTStockMarketConstants.GreenColor ?? .green
        default:
            return TTStockMarketConstants.GreyColor ?? .gray
        }
    }
}
