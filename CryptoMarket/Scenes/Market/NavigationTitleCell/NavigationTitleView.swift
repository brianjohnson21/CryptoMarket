//
//  NavigationTitleView.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 13/01/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit

class NavigationTitleView: UIView {

    @IBOutlet private weak var iconTitle: UIImageView!
    @IBOutlet private weak var titleName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setup(title: String, icon: UIImage) {
        self.iconTitle.image = icon
        self.titleName.text = title
    }
    
}
