//
//  PersistanceManager.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

enum SelectedTab: Int {
    case symbolList = 0
    case news
    case info
    case symbolRows
}

enum SelectedFormat: String{
    case changePercentLast
    case bidAsk
    case highLow
}

enum SelectedSorting: String {
    case defaultSorting
    case ascendingSorting
    case descendingSorting
}

class PersistanceManager {
    struct Constants {
        static let UserDefaultsKeyForSelectedSorting = "LastSelectedSorting"
        static let UserDefaultsKeyForSelectedFormat = "LastSelectedFormat"
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
    
    var lastSelectedFormat: SelectedFormat {
        get {
            let selectedFormatRawValue = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeyForSelectedFormat) ?? "changePercentLast"
            return SelectedFormat(rawValue: selectedFormatRawValue) ?? SelectedFormat.changePercentLast
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.UserDefaultsKeyForSelectedFormat)
        }
    }
    
    var lastSelectedSorting: SelectedSorting {
        get {
            let selectedSortingRawValue = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeyForSelectedSorting) ?? "defaultSorting"
            return SelectedSorting(rawValue: selectedSortingRawValue) ?? SelectedSorting.defaultSorting
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.UserDefaultsKeyForSelectedSorting)
        }
    }
}
