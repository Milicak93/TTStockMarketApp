//
//  TTButton.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class TTButton: UIButton {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        backgroundColor = .clear
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = TTStockMarketConstants.LabelColor?.cgColor
    }
    
    // Reload border color when mode changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        customInit()
    }
}
