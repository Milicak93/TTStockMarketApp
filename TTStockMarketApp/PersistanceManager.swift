//
//  PersistanceManager.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import Foundation

enum SelectedTab: Int {
    case symbolList = 0
    case news
    case info
}

class PersistanceManager {
    struct Constants {
        static let UserDefaultsKeyForSelectedTab = "LastSelectedTabKey"
        static let DefaultSelectedTab = 0
    }
    
    static let shared = PersistanceManager()
    
    private init() {}
    
    var lastSelectedIndex: SelectedTab {
        get {
            let selectedTabRawValue = UserDefaults.standard.integer(forKey: Constants.UserDefaultsKeyForSelectedTab)
            return SelectedTab(rawValue: selectedTabRawValue) ?? SelectedTab.symbolList
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.UserDefaultsKeyForSelectedTab)
        }
    }
}
