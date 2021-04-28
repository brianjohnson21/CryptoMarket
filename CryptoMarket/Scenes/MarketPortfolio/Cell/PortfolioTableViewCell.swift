//
//  PortfolioTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 28/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var loadingImage: UIActivityIndicatorView!
    @IBOutlet private weak var portfolioImage: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var footName: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var percentageLabel: UILabel!
    
    public var title: String? {
        set { self.name.text = newValue }
        get { return self.name.text }
    }
    
    public var portfolioLogoImage: UIImage? {
        set { self.portfolioImage?.image = newValue }
        get { return self.portfolioImage?.image }
    }
    
    public var index: String? {
        set { self.id.text = newValue }
        get { return self.id.text }
    }
    
    public var price: String? {
        set { self.priceLabel.text = newValue }
        get { return self.priceLabel.text }
    }
    
    public var percentage: String? {
        set { self.percentageLabel.text = newValue }
        get { return self.percentageLabel.text }
    }
    
    public var symbol: String? {
        set { self.footName.text = newValue }
        get { return self.footName.text }
    }
    
    public func loadImageOnCell(name: String) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
