//
//  HeaderInformationTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 16/12/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

class HeaderInformationTableViewCell: UITableViewCell {

    @IBOutlet private weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var title: String? {
        get {
            return self.headerLabel.text
        }
        set {
            self.headerLabel.text = newValue
        }
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
