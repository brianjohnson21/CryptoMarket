//
//  MarketInformationViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 23/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public final class MarketInformationViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let market: Market
    
    struct Input {}
    struct Output {
        let navigationTitle: String
    }
    
    init(marketSelected: Market) {
        
        self.market = marketSelected
    }
    
    func transform(input: Input) -> Output {
        
        return Output(navigationTitle: self.market.name ?? "Market Chart")
    }
}
