//
//  MoneyTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 04/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit

class MoneyTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var isCheckImage: UIImageView!
    @IBOutlet private weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    internal static var identifier: String {
        return String(describing: self)
    }
    
    internal static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: .main)
    }
}
