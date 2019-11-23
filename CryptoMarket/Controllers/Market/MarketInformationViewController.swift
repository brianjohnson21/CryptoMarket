//
//  MarketInformationViewController.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 16/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MarketInformationViewController: UIViewController {

    //MARK: Members
    //TODO: change ->
    private var viewModel: MarketInformationViewModel!
    private let disposeBag = DisposeBag()
    private var toto: String = ""
    
    //MARK: Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        let input = MarketInformationViewModel.Input()
        let output = self.viewModel.transform(input: input)
        
//        output.navigationTitle
//            .observeOn(MainScheduler.instance)
//            .subscribeOn(MainScheduler.asyncInstance)
//            .bind(to: self.navigationItem.rx.title)
//            .disposed(by: self.disposeBag)
        
        self.navigationItem.title = output.navigationTitle
    }
    
    public func setup(marketSelected: Market) {
        self.viewModel = MarketInformationViewModel(marketSelected: marketSelected)
    }

}
