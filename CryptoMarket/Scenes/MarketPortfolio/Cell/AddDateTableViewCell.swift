//
//  AddDateTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas on 03/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit

class AddDateTableViewCell: UITableViewCell {

    @IBOutlet private weak var Label: UILabel!
    @IBOutlet private weak var DatePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal var title: String? {
        get { return self.Label.text }
        set { self.Label.text = newValue }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: .main)
    }
}
