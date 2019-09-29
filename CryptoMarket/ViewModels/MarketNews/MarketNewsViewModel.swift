//
//  MarketNewsViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 16/09/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Keys

public final class MarketNewsViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {}
    struct Output {
        let collectionViewDataSource: Observable<[MarketNews]>
    }
    
    private func fetchMarketNewsData() -> Observable<[MarketNews]> {
        return Network.sharedInstance.performGetOnNews(stringUrl: ApiRoute.ROUTE_SERVER_NEWS.concat(string: ApiRoute.ROUTE_NEWS_CRYPTOCURRENCY))
    }
    
    func transform(input: Input) -> Output {
        
        let collectionViewDataSource = self.fetchMarketNewsData()
        
        return Output(collectionViewDataSource: collectionViewDataSource)
    }
}
