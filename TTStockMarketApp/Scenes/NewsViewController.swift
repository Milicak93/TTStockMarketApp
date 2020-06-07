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
    }
    
    // MARK: - Outlets
    @IBOutlet weak var newsTableView: UITableView!
    
    // MARK: Properties
    var newsList: [News] = []
    var selectedNews: News?
    
    // MARK: - Helper properties
    fileprivate var id: String = .empty
    fileprivate var author: String = .empty
    fileprivate var dateTime: String = .empty
    fileprivate var sourceName: String = .empty
    fileprivate var headline: String = .empty
    fileprivate var imageId: Int = 0
    fileprivate var didEnterTag: Bool = false
    fileprivate var currentlyReadValue: String = .empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getNews(xmlParserDelegate: self)
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
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == TTStockMarketConstants.NewsArticeXMLTag {
            id = attributeDict["id"] ?? .missingInfoPlaceholder
            author = attributeDict["author"] ?? .missingInfoPlaceholder
            dateTime = attributeDict["dateTime"] ?? .missingInfoPlaceholder
            sourceName = attributeDict["sourceName"] ?? .missingInfoPlaceholder
        }
        if elementName == TTStockMarketConstants.HeadlineXMLTag {
            didEnterTag = true
        }
        if elementName == TTStockMarketConstants.ImageIdXMLTag {
            didEnterTag = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if didEnterTag {
            currentlyReadValue += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == TTStockMarketConstants.StartAndEndXMLTag {
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
        if elementName == TTStockMarketConstants.NewsArticeXMLTag {
            newsList.append(News(id: id, author: author, dateTime: dateTime, sourceName: sourceName, headline: headline, imageId: imageId))
        }
        if elementName == TTStockMarketConstants.HeadlineXMLTag {
            headline = currentlyReadValue
            didEnterTag = false
            currentlyReadValue = .empty
        }
        if elementName == TTStockMarketConstants.ImageIdXMLTag {
            imageId = Int(currentlyReadValue) ?? 0
            didEnterTag = false
            currentlyReadValue = .empty
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
