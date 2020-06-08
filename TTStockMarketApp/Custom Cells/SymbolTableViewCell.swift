//
//  SymbolTableViewCell.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class SymbolTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var firstPropertyLbl: UILabel!
    @IBOutlet weak var seconPropertyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @discardableResult
    func populate(name: String, firstProperty: String, secondProperty: String, isShowingChangeValue: Bool) -> Self {
        nameLbl.text = name
        firstPropertyLbl.text = firstProperty
        seconPropertyLbl.text = secondProperty
        if isShowingChangeValue {
            firstPropertyLbl.textColor = FontColorUtility.fontColorBasedOnSymbolChange(change: firstProperty)
        } else {
            firstPropertyLbl.textColor = TTStockMarketConstants.LabelColor
        }
        
        return self
    }
}
