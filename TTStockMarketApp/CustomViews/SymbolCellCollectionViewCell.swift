//
//  SymbolCellCollectionViewCell.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 06/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class SymbolCellCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    struct Constants {
        static let SymbolChangeLimit = Float(0.0)
    }
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
        
        let changeValue = Float(data.quote.change) ?? Constants.SymbolChangeLimit
        switch changeValue {
        case _ where changeValue < Constants.SymbolChangeLimit:
            contentView.layer.backgroundColor = UIColor.red.cgColor
        case _ where changeValue == Constants.SymbolChangeLimit:
            contentView.layer.backgroundColor = UIColor.gray.cgColor
        case _ where changeValue > Constants.SymbolChangeLimit:
            contentView.layer.backgroundColor = UIColor.green.cgColor
        default:
            break
        }
        return self
    }
}
