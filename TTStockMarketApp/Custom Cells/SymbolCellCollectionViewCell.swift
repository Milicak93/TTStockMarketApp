//
//  SymbolCellCollectionViewCell.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 06/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class SymbolCellCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    @IBOutlet weak var symbolNameLbl: UILabel!
    @IBOutlet weak var quoteLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
    }
    
    @discardableResult
    func populateCell(with data: Symbol) -> Self {
        symbolNameLbl.text = data.name
        quoteLbl.text = data.quote.last
        highLbl.text = data.quote.high
        lowLbl.text = data.quote.low
        contentView.layer.backgroundColor = FontColorUtility.fontColorBasedOnSymbolChange(change: data.quote.change).cgColor
        
        return self
    }
}
