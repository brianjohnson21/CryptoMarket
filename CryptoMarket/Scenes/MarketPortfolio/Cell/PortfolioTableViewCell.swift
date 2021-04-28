//
//  PortfolioTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 28/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

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
