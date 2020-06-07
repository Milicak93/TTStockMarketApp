//
//  SymbolDetailTableViewCell.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class SymbolDetailTableViewCell: UITableViewCell {
    struct Constants {
        static let MissingInfoPlaceholder = "-"
    }
    
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var propertyValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @discardableResult
    func populate(with propertyName: String, value: String) -> Self {
        property.text = propertyName
        propertyValue.text = value.isEmpty ? Constants.MissingInfoPlaceholder : value
        return self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
