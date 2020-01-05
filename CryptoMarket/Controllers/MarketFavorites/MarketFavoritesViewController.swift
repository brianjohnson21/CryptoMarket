//
//  MarketFavoritesViewController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 21/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

class MarketFavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.navigationItem.title = "Favorites"
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainColor")
    }
}
