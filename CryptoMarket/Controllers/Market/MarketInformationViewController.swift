//
//  MarketInformationViewController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 16/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit

class MarketInformationViewController: UIViewController {

    @IBOutlet private weak var downImage: UIImageView!
    @IBOutlet private weak var upImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Inside Market"
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainColor")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        
        print("** -> Inside setup Nav bar \(self.navigationController)")
        
    }

}
