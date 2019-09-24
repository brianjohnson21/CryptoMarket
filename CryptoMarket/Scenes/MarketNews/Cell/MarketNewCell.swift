//
//  MarketNewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 24/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

class MarketNewCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    //MARK: Members
    public var title: String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
