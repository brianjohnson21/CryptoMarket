//
//  UIImageView+Ext.swift
//  CryptoMarket
//
//  Created by Thomas on 17/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

extension UIImageView {
   func setRounded() {
    
    let radius = self.frame.width / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}
