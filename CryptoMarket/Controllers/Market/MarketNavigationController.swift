//
//  MarketNavigationController.swift
//  CryptoMarket
//
//  Created by Thomas on 25/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

class MarketNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Market news here"
    }


}


extension UINavigationController {

   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
