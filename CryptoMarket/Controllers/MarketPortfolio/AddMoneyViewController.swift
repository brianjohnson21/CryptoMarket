//
//  AddMoneyViewController.swift
//  CryptoMarket
//
//  Created by Thomas on 04/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import UIKit

class AddMoneyViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var row: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    internal func setup(with vm: AddPortfolioViewModel, with row: Int) {
        self.row = row
    }
}
