//
//  MarketViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 05/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public final class MarketViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
    }
    
    struct Output {
        let tableViewDataSource: Observable<[Market]>
    }
    
    private func fetchMarketData() -> Observable<[Market]> {
        return Network.sharedInstance.perfromGetRequest(stringUrl: ApiRoute.ROUTE_SERVER.concat(string: ApiRoute.ROUTE_MARKET))
    }
    
    func transform(input: Input) -> Output {
        
        let tableViewDataSource: Observable<[Market]> = self.fetchMarketData().asObservable()

        return Output(tableViewDataSource: tableViewDataSource)
    }
}
