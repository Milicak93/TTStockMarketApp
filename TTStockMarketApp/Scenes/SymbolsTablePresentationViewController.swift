//
//  SymbolsTablePresentationViewController.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class SymbolsTablePresentationViewController: BaseSymbolXMLParser {
    struct Constants {
        static let SymbolCellIdentifier = "SymbolTableViewCell"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var refreshControl = UIRefreshControl()

    var presentedSymbolList: [Symbol] = []
    var defaultSymbolList: [Symbol] = []
    
    var currentlySelectedFormat: SelectedFormat {
        return PersistanceManager.shared.lastSelectedFormat
    }
    
    var currentlySelectedSorting: SelectedSorting {
        return PersistanceManager.shared.lastSelectedSorting
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        configurePullToRefresh()
    }
    
    func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshData() {
        NetworkManager.shared.getSymbols(xmlParserDelegate: self)
        super.parsingCompletionHandler = {
            DispatchQueue.main.async {
                self.defaultSymbolList = super.symbolList
                self.preparePresentingSymbolList()
                self.refreshControl.endRefreshing()
            }
        }
    }

    // MARK: - Actions
    @IBAction func defaultSortingButtonPressed(_ sender: Any) {
        PersistanceManager.shared.lastSelectedSorting = SelectedSorting.defaultSorting
        preparePresentingSymbolList()
    }
    
    @IBAction func ascendingSortingButtonPressed(_ sender: Any) {
        PersistanceManager.shared.lastSelectedSorting = SelectedSorting.ascendingSorting
        preparePresentingSymbolList()
    }
    
    @IBAction func descendingSortingButtonPressed(_ sender: Any) {
        PersistanceManager.shared.lastSelectedSorting = SelectedSorting.descendingSorting
        preparePresentingSymbolList()
    }
    
    @IBAction func changeLastFormatButtonPressed(_ sender: Any) {
        PersistanceManager.shared.lastSelectedFormat = SelectedFormat.changePercentLast
        tableView.reloadData()
    }
    
    @IBAction func bidAskFormatButtonPressed(_ sender: Any) {
        PersistanceManager.shared.lastSelectedFormat = SelectedFormat.bidAsk
        tableView.reloadData()
    }
    
    @IBAction func highLowFormatButtonPressed(_ sender: Any) {
        PersistanceManager.shared.lastSelectedFormat = SelectedFormat.highLow
        tableView.reloadData()
    }
    
    private func preparePresentingSymbolList() {
        switch currentlySelectedSorting {
        case .ascendingSorting:
            presentedSymbolList = defaultSymbolList.sorted(by: { $0.name < $1.name } )
        case .descendingSorting:
            presentedSymbolList = defaultSymbolList.sorted(by: { $0.name > $1.name })
        case .defaultSorting:
            presentedSymbolList = defaultSymbolList
        }
        tableView.reloadData()
    }
}

extension SymbolsTablePresentationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentedSymbolList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SymbolCellIdentifier, for: indexPath) as? SymbolTableViewCell else { return UITableViewCell() }
        let symbol = presentedSymbolList[indexPath.row]
        var firstProperty: String = .missingInfoPlaceholder
        var secondProperty: String = .missingInfoPlaceholder
        var isShowingChangeValue: Bool = false
        
        switch currentlySelectedFormat {
        case .bidAsk:
            firstProperty = symbol.quote.bid
            secondProperty = symbol.quote.ask
        case .changePercentLast:
            firstProperty = symbol.quote.changePercent
            secondProperty = symbol.quote.last
            isShowingChangeValue = true
        case .highLow:
            firstProperty = symbol.quote.high
            secondProperty = symbol.quote.low
        }
        
        cell.populate(name: symbol.name, firstProperty: firstProperty, secondProperty: secondProperty, isShowingChangeValue: isShowingChangeValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedSymbolId = presentedSymbolList[indexPath.row].id
            if let deletedIndex = defaultSymbolList.firstIndex(where: { $0.id == deletedSymbolId }) {
                    defaultSymbolList.remove(at: deletedIndex)
            }
            presentedSymbolList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
