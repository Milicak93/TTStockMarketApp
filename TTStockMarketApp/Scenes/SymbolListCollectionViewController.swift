//
//  SymbolListCollectionViewController.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 06/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class SymbolListCollectionViewController: BaseSymbolXMLParser {
    struct Constants {
        static let SymbolCellIdentifier = "SymbolCell"
        static let ShowSymbolDetailsSegue = "showSymbolDetails"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var selectedSymbol: Symbol?

    // MARK: - Helper properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getSymbols(xmlParserDelegate: self)
        super.parsingCompletionHandler = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension SymbolListCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return symbolList.count
       }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.SymbolCellIdentifier, for: indexPath) as? SymbolCellCollectionViewCell,
               !symbolList.isEmpty
           else { return UICollectionViewCell() }
           cell.populateCell(with: symbolList[indexPath.row])
               
           return cell
       }
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           selectedSymbol = symbolList[indexPath.row]
           presentSymbolDetails()
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
