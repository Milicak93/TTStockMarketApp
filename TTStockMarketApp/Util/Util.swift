//
//  Util.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

protocol PropertyLoopable {
    func allProperties() throws -> [String: Any]
}

extension PropertyLoopable {
    func allProperties() throws -> [String: Any] {
        var result: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        guard let style = mirror.displayStyle, style == .struct else { throw NSError() }

        for (property, value) in mirror.children {
            guard let property = property else { continue }
            result[property] = value
        }
        return result
    }
}


protocol CustomizeFontColorProtocol {
    func fontColorBasedOnSymbolChange(change value: String) -> UIColor
}

extension CustomizeFontColorProtocol {

    func fontColorBasedOnSymbolChange(change value: String) -> UIColor {
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
