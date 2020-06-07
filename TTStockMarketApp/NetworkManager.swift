//
//  NetworkManager.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    struct Constants {
        struct SymbolsRequest {
            static let Username = "android_tt"
            static let Password = "Sk3M!@p9e"
            static let RequestMethod = "GET"
            static let RequestPath = "http://www.teletrader.rs/downloads/tt_symbol_list.xml"
        }
        struct NewsRequest {
            static let RequestPath = "http://www.teletrader.rs/downloads/tt_news_list.xml"
            static let Username = "android_tt"
            static let Password = "Sk3M!@p9e"
            static let RequestMethod = "Get"
        }
    }

    static let shared = NetworkManager()
        
    private override init() {}
    
    func getSymbols(xmlParserDelegate: XMLParserDelegate) {
        // credentials encoded in base64
        let username = Constants.SymbolsRequest.Username
        let password = Constants.SymbolsRequest.Password
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()

        // create the request
        guard let url = URL(string: Constants.SymbolsRequest.RequestPath) else { assertionFailure("Couldn't create URL"); return }
        var request = URLRequest(url: url)
        request.httpMethod = Constants.SymbolsRequest.RequestMethod
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")

        //making the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { assertionFailure("Found an error!"); return }

            if let httpStatus = response as? HTTPURLResponse {
                // check status code returned by the http server
                print("status code = \(httpStatus.statusCode)")
                // process result
                let parser = XMLParser(data: data)
                parser.delegate = xmlParserDelegate
                parser.parse()
            }
        }.resume()
    }
    
    func getNews(xmlParserDelegate: XMLParserDelegate) {
        // credentials encoded in base64
        let username = Constants.NewsRequest.Username
        let password = Constants.NewsRequest.Password
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()

        // create the request
        guard let url = URL(string: Constants.NewsRequest.RequestPath) else { assertionFailure("Couldn't create URL"); return }
        var request = URLRequest(url: url)
        request.httpMethod = Constants.NewsRequest.RequestMethod
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")

        //making the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { assertionFailure("Found an error!"); return }

            if let httpStatus = response as? HTTPURLResponse {
                // check status code returned by the http server
                print("status code = \(httpStatus.statusCode)")
                // process result
                let parser = XMLParser(data: data)
                parser.delegate = xmlParserDelegate
                parser.parse()
            }
        }.resume()
    }
    
}
