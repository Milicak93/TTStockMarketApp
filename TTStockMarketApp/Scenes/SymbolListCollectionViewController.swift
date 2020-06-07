//
//  SymbolListCollectionViewController.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 06/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class SymbolListCollectionViewController: UICollectionViewController {
    struct Constants {
        static let SymbolCellIdentifier = "SymbolCell"
        static let ShowSymbolDetailsSegue = "showSymbolDetails"
    }
    
    // MARK: - Properties
    var symbolList: [Symbol] = []
    var selectedSymbol: Symbol?
    
    // Symbol properties
    fileprivate var id = ""
    fileprivate var name = ""
    fileprivate var tickerSymbol = ""
    fileprivate var isin = ""
    fileprivate var currency = ""
    fileprivate var stockExchangeName = ""
    fileprivate var decorativeName = ""
    // Quote properties
    fileprivate var last = ""
    fileprivate var high = ""
    fileprivate var low = ""
    fileprivate var bid = ""
    fileprivate var ask = ""
    fileprivate var volume = ""
    fileprivate var dateTime = ""
    fileprivate var change = ""
    fileprivate var changePercent = ""
    
    // MARK: - Helper properties

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getSymbols(xmlParserDelegate: self)
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.SymbolCellIdentifier, for: indexPath) as? SymbolCellCollectionViewCell,
            !symbolList.isEmpty
        else { return UICollectionViewCell() }
        cell.populateCell(with: symbolList[indexPath.row])
            
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSymbol = symbolList[indexPath.row]
        presentSymbolDetails()
    }
}

extension SymbolListCollectionViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        guard elementName == "Symbol" || elementName == "Quote" else { return }
        
        if elementName == "Symbol" {
            id = attributeDict["id"] ?? ""
            name = attributeDict["name"] ?? ""
            tickerSymbol = attributeDict["tickerSymbol"] ?? ""
            isin = attributeDict["isin"] ?? ""
            currency = attributeDict["currency"] ?? ""
            stockExchangeName = attributeDict["stockExchangeName"] ?? ""
            decorativeName = attributeDict["decorativeName"] ?? ""
        }
        if elementName == "Quote" {
            last = attributeDict["last"] ?? ""
            high = attributeDict["high"] ?? ""
            low = attributeDict["low"] ?? ""
            bid = attributeDict["bid"] ?? ""
            ask = attributeDict["ask"] ?? ""
            volume = attributeDict["volume"] ?? ""
            dateTime = attributeDict["dateTime"] ?? ""
            change = attributeDict["change"] ?? ""
            changePercent = attributeDict["changePercent"] ?? ""
        
        let quote = Quote(
            last: last,
            high: high,
            low: low,
            bid: bid,
            ask: ask,
            volume: volume,
            dateTime: dateTime,
            change: change,
            changePercent: changePercent)
        let symbol = Symbol(
            id: id,
            name: name,
            tickerSymbol: tickerSymbol,
            isin: isin,
            currency: currency,
            stockExchangeName: stockExchangeName,
            decorativeName: decorativeName,
            quote: quote)
        symbolList.append(symbol)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Result" {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension SymbolListCollectionViewController {
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == Constants.ShowSymbolDetailsSegue,
            let symbolDetailsVC = segue.destination as? SymbolDetailsTableViewController {
            symbolDetailsVC.selectedSymbol = selectedSymbol
        }
    }
    
    func presentSymbolDetails() {
        self.performSegue(withIdentifier: Constants.ShowSymbolDetailsSegue, sender: nil)
    }
}
