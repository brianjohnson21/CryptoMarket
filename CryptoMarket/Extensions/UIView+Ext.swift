//
//  UIView+Ext.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 13/01/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
