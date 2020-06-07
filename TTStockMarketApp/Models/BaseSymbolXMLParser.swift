//
//  BaseSymbolXMLParser.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class BaseSymbolXMLParser: UIViewController, XMLParserDelegate {
    var symbolList: [Symbol] = []
    var parsingCompletionHandler: (() -> ())?
    
    // Symbol properties
    fileprivate var id: String = .empty
    fileprivate var name: String = .empty
    fileprivate var tickerSymbol: String = .empty
    fileprivate var isin: String = .empty
    fileprivate var currency: String = .empty
    fileprivate var stockExchangeName: String = .empty
    fileprivate var decorativeName: String = .empty
    // Quote properties
    fileprivate var last: String = .empty
    fileprivate var high: String = .empty
    fileprivate var low: String = .empty
    fileprivate var bid: String = .empty
    fileprivate var ask: String = .empty
    fileprivate var volume: String = .empty
    fileprivate var dateTime: String = .empty
    fileprivate var change: String = .empty
    fileprivate var changePercent: String = .empty
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == TTStockMarketConstants.StartAndEndXMLTag {
            symbolList.removeAll()
        }
        guard elementName == TTStockMarketConstants.SymbolXMLTag || elementName == TTStockMarketConstants.QuoteXMLTag else { return }
        
        if elementName == TTStockMarketConstants.SymbolXMLTag {
            id = attributeDict["id"] ?? .missingInfoPlaceholder
            name = attributeDict["name"] ?? .missingInfoPlaceholder
            tickerSymbol = attributeDict["tickerSymbol"] ?? .missingInfoPlaceholder
            isin = attributeDict["isin"] ?? .missingInfoPlaceholder
            currency = attributeDict["currency"] ?? .missingInfoPlaceholder
            stockExchangeName = attributeDict["stockExchangeName"] ?? .missingInfoPlaceholder
            decorativeName = attributeDict["decorativeName"] ?? .missingInfoPlaceholder
        }
        if elementName == TTStockMarketConstants.QuoteXMLTag {
            last = attributeDict["last"] ?? .missingInfoPlaceholder
            high = attributeDict["high"] ?? .missingInfoPlaceholder
            low = attributeDict["low"] ?? .missingInfoPlaceholder
            bid = attributeDict["bid"] ?? .missingInfoPlaceholder
            ask = attributeDict["ask"] ?? .missingInfoPlaceholder
            volume = attributeDict["volume"] ?? .missingInfoPlaceholder
            dateTime = attributeDict["dateTime"] ?? .missingInfoPlaceholder
            change = attributeDict["change"] ?? .missingInfoPlaceholder
            changePercent = attributeDict["changePercent"] ?? .missingInfoPlaceholder
            
            let quote = Quote(last: last, high: high, low: low, bid: bid, ask: ask, volume: volume, dateTime: dateTime, change: change, changePercent: changePercent)
            let symbol = Symbol(id: id, name: name, tickerSymbol: tickerSymbol, isin: isin, currency: currency, stockExchangeName: stockExchangeName, decorativeName: decorativeName, quote: quote)
            symbolList.append(symbol)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == TTStockMarketConstants.StartAndEndXMLTag {
            parsingCompletionHandler?()
        }
    }
}
