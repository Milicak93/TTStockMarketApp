//
//  InfoViewController.swift
//  StockMarketApp
//
//  Created by Milica Kostic on 05/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class InfoViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    struct Constants {
        static let PDFFileExtension = "pdf"
        static let ResourceFile = "Milica_Kostic_2020CV"
    }

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createPDFUrl()
    }
    
    private func createPDFUrl() {
        // Fetch pdf url
        guard let documentURL = Bundle.main.url(forResource: Constants.ResourceFile, withExtension: Constants.PDFFileExtension, subdirectory: nil, localization: nil) else { return }
        let urlRequest = URLRequest(url: documentURL)
        // Setup WKWebView
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(urlRequest)
        webView.contentMode = .scaleAspectFit
        self.containerView.addSubview(webView)
        self.containerView.bringSubviewToFront(webView)
    }
}
