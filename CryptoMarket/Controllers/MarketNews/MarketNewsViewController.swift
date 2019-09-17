//
//  MarketNewsViewController.swift
//  CryptoMarket
//
//  Created by Thomas on 16/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift

class MarketNewsViewController: UIViewController {
    
    // private MARK: Members
    private let viewModel: MarketNewsViewModel = MarketNewsViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        
        
    }

}

extension MarketNewsViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
