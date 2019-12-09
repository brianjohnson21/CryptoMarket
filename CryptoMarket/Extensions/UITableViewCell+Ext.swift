//
//  UITableViewCell+Ext.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 09/12/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func setSelectedBackgroundColor(selectedColor color: UIColor) {
        let bgColorView = UIView()
        bgColorView.backgroundColor = color
        self.selectedBackgroundView = bgColorView
    }
}
