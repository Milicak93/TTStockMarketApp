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
        static let CellInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
        struct Request {
            static let Username = "android_tt"
            static let Password = "Sk3M!@p9e"
            static let RequestMethod = "GET"
            static let RequestPath = "http://www.teletrader.rs/downloads/tt_symbol_list.xml"
        }
    }
    
    // MARK: - Properties
    var symbolList: [Symbol] = []
    
    // MARK: - Helper properties
    // Symbol properties
    var id = ""
    var name = ""
    var tickerSymbol = ""
    var isin = ""
    var currency = ""
    var stockExchangeName = ""
    var decorativeName = ""
    // Quote properties
    var last = ""
    var high = ""
    var low = ""
    var bid = ""
    var ask = ""
    var volume = ""
    var dateTime = ""
    var change = ""
    var changePercent = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSymbolList()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper methods
    private func setupCollectionView() {
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.SymbolCellIdentifier)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.SymbolCellIdentifier, for: indexPath)
    
        // Configure the cell
        cell.backgroundColor = .blue
        return cell
    }
}

extension SymbolListCollectionViewController: XMLParserDelegate {
    func fetchSymbolList() {
        // credentials encoded in base64
        let username = Constants.Request.Username
        let password = Constants.Request.Password
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        // create the request
        guard let url = URL(string: Constants.Request.RequestPath) else { assertionFailure("Couldn't create URL"); return }
        var request = URLRequest(url: url)
        request.httpMethod = Constants.Request.RequestMethod
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        //making the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { assertionFailure("Found an error!"); return }
            
            if let httpStatus = response as? HTTPURLResponse {
                // check status code returned by the http server
                print("status code = \(httpStatus.statusCode)")
                // process result
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        }
        task.resume()
    }
    
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