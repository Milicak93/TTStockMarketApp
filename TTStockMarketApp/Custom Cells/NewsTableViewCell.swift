//
//  NewsTableViewCell.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 06/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    struct Constants {
        static let ImageUrl = "https://cdn.ttweb.net/News/images/%d.jpg?preset=w220_q40"
    }

    // MARK: - Properties
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsHeadlineLbl: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @discardableResult
    func populate(with data: News) -> Self {
        newsTitleLbl.text = data.headline
        newsHeadlineLbl.text = data.headline
        
        let formatImageUrl = String(format: Constants.ImageUrl, data.imageId)
        if let imageUrl = URL(string: formatImageUrl) {
            newsImage.downloaded(from: imageUrl, contentMode: .scaleAspectFill)
        }
        
        return self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
