//
//  SymbolDetailsTableViewController.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 06/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class SymbolDetailsTableViewController: UITableViewController {
    struct Constants {
        static let SymbolDetailCellIdentifier = "SymbolDetailCell"
        static let DefaultDateInputFormat = "yyyy-MM-dd'T'HH:mm:ss"
        static let DefaultDateOutputFormat = "dd.MM.yy"
    }
    
    // MARK: - Properties
    var selectedSymbol: Symbol?

    // MARK: - Outlets
    @IBOutlet weak var symbolDetailsHeaderView: UIView!
    @IBOutlet weak var symbolNameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateHeaderSection()
    }
    
    private func populateHeaderSection() {
        guard let symbol = selectedSymbol else { assertionFailure("Selected symbol is not properly passed!"); return }
        symbolNameLbl.text = symbol.name
        dateTimeLbl.text = formatDate(dateToFormat: symbol.quote.dateTime)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    // MARK: - Helper methods
    
    private func formatDate(dateToFormat: String, dateInputFormat: String = Constants.DefaultDateInputFormat, dateOutputFormat: String = Constants.DefaultDateOutputFormat) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateInputFormat
        let date = dateFormater.date(from: dateToFormat)
        guard let formattedDate = date else {
            return .empty
        }
        dateFormater.dateFormat = dateOutputFormat
        return dateFormater.string(from: formattedDate)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SymbolDetailCellIdentifier, for: indexPath) as? SymbolDetailTableViewCell,
            let symbol = selectedSymbol
        else { return UITableViewCell() }

        switch indexPath.row {
        case 0: cell.populate(with: "Ticker Symbol", value: symbol.tickerSymbol)
        case 1: cell.populate(with: "ISIN", value: symbol.isin)
        case 2: cell.populate(with: "Currency", value: symbol.currency)
        case 3: cell.populate(with: "Stock Exchange Name", value: symbol.stockExchangeName)
        case 4: cell.populate(with: "Last", value: symbol.quote.last)
        case 5: cell.populate(with: "High", value: symbol.quote.high)
        case 6: cell.populate(with: "Low", value: symbol.quote.low)
        case 7: cell.populate(with: "Bid", value: symbol.quote.bid)
        case 8: cell.populate(with: "Ask", value: symbol.quote.ask)
        default: break
        }
        
        return cell
    }
}
