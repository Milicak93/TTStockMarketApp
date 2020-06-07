//
//  NewsViewController.swift
//  StockMarketApp
//
//  Created by Milica Kostic on 05/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    // MARK: - Constants
    struct Constants {
        static let NewsCellIdentifier = "NewsCell"
        static let NewsDetailsSegueIdentifier = "showNewsDetails"
        struct Request {
            static let RequestPath = "http://www.teletrader.rs/downloads/tt_news_list.xml"
            static let Username = "android_tt"
            static let Password = "Sk3M!@p9e"
            static let RequestMethod = "Get"
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var newsTableView: UITableView!
    
    // MARK: Properties
    var newsList: [News] = []
    var selectedNews: News?
    
    // MARK: - Helper properties
    var id: String = ""
    var author: String = ""
    var dateTime: String = ""
    var sourceName: String = ""
    var headline: String = ""
    var imageId: Int = 0
    var didEnterTag: Bool = false
    var currentlyReadValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNewsList()
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.NewsCellIdentifier, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        cell.populate(with: newsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNews = newsList[indexPath.row]
        presentNewsDetails()
    }
}

// MARK: - XMLParserDelegate
extension NewsViewController: XMLParserDelegate {
    func fetchNewsList() {
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
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { assertionFailure("Found an error!"); return }

            if let httpStatus = response as? HTTPURLResponse {
                // check status code returned by the http server
                print("status code = \(httpStatus.statusCode)")
                // process result
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        }.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "NewsArticle" {
            id = attributeDict["id"] ?? ""
            author = attributeDict["author"] ?? ""
            dateTime = attributeDict["dateTime"] ?? ""
            sourceName = attributeDict["sourceName"] ?? ""
        }
        if elementName == "Headline" {
            didEnterTag = true
        }
        if elementName == "ImageID" {
            didEnterTag = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if didEnterTag {
            currentlyReadValue += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Result" {
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
        if elementName == "NewsArticle" {
            newsList.append(News(id: id, author: author, dateTime: dateTime, sourceName: sourceName, headline: headline, imageId: imageId))
        }
        if elementName == "Headline" {
            headline = currentlyReadValue
            didEnterTag = false
            currentlyReadValue = ""
        }
        if elementName == "ImageID" {
            imageId = Int(currentlyReadValue) ?? 0
            didEnterTag = false
            currentlyReadValue = ""
        }
    }
}

// MARK: - Navigation

extension NewsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == Constants.NewsDetailsSegueIdentifier,
            let newsDetailsVC = segue.destination as? NewsDetailsViewController {
            newsDetailsVC.selectedNews = selectedNews
        }
    }
    
    func presentNewsDetails() {
        performSegue(withIdentifier: Constants.NewsDetailsSegueIdentifier, sender: nil)
    }
}
