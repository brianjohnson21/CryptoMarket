//
//  ViewController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 05/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture


class MarketController: UIViewController {

    // MARK: Members
    private let viewModel: MarketViewModel = MarketViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewModel()
    }
    
    private func setUpViewModel() {
        
        let input = MarketViewModel.Input()
        


        _ = self.viewModel.transform(input: input)
        
        
    }


}

