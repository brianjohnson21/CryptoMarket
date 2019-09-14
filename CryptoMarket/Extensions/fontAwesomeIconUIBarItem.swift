//
//  BarItem.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 14/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import FontAwesome_swift

@IBDesignable final class fontAwesomeIconUIBarItem: UITabBarItem {
    
    @IBInspectable public var fontAwesomeItem: String?
    
    override func awakeFromNib() {

        self.image = UIImage.fontAwesomeIcon(name: FontAwesome(rawValue: "\(fontAwesomeItem ?? "")") ?? .random, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Font Awesome 5 Pro", size: 12)!], for: .normal)
    }
}
