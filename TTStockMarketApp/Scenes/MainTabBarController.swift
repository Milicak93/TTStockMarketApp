//
//  MainTabBarController.swift
//  StockMarketApp
//
//  Created by Milica Kostic on 05/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = PersistanceManager.shared.lastSelectedIndex.rawValue
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        PersistanceManager.shared.lastSelectedIndex = SelectedTab(rawValue: selectedIndex) ?? .symbolList
    }

}
