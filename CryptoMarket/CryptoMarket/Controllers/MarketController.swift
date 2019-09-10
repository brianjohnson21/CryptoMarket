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
    @IBOutlet private weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewModel()
    }
    
    private func setUpViewModel() {
        
        let input = MarketViewModel.Input()
        
        self.addButton.rx.tap.subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (_) in
            
            let newVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMarketController")
                as! AddMarketController
            self.navigationController?.pushViewController(newVc, animated: true)
                
        }).disposed(by: self.disposeBag)
        

        _ = self.viewModel.transform(input: input)
        
        
    }


}

