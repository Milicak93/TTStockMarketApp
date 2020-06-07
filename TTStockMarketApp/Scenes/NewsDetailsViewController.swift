//
//  NewsDetailsViewController.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 07/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    struct Constants {
        static let PortraitImagePresets = "preset=w320_q50"
        static let LandscapeImagePresets = "preset=w800_q70"
        static let ImageUrl = "https://cdn.ttweb.net/News/images/%d.jpg?%@"
    }
    
    //MARK: - Outlets
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var imageHeadlineLbl: UILabel!
    @IBOutlet weak var mainHeadlineLbl: UILabel!
    
    // MARK: - Properties
    var selectedNews: News?

    override func viewDidLoad() {
        super.viewDidLoad()
        populateHeadlines()
        downloadImage()
    }
    
    func populateHeadlines() {
        guard let selectedNews = selectedNews else { return }
        imageHeadlineLbl.text = selectedNews.headline
        mainHeadlineLbl.text = selectedNews.headline
    }
    
    func downloadImage() {
        guard let news = selectedNews else { return }
        var formatUrl: String = ""
        if UIDevice.current.orientation.isPortrait {
            formatUrl = String(format: Constants.ImageUrl, news.imageId, Constants.PortraitImagePresets)
        } else if UIDevice.current.orientation.isLandscape {
            formatUrl = String(format: Constants.ImageUrl, news.imageId, Constants.LandscapeImagePresets)
        }
        if let imageUrl = URL(string: formatUrl) {
            newsImage.downloaded(from: imageUrl, contentMode: .scaleAspectFill)
        }
    }
    
    // Monitor for orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        downloadImage()
    }

}
