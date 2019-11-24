//
//  MarketInformationTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 23/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {

    @IBOutlet private weak var informationTitle: UILabel!
    @IBOutlet private weak var detailTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public var detail: String? {
        get {
            return self.detailTitle.text
        }
        set {
            self.detailTitle.text = newValue
        }
    }
    
    public var title: String? {
        get {
            return self.informationTitle.text
        }
        set {
            self.informationTitle.text = newValue
        }
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
