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
    private let isLoading = PublishSubject<Bool>()
    
    struct Input {}
    struct Output {
        let collectionViewDataSource: Observable<[MarketNews]>
        let isLoading: Observable<Bool>
    }
    
    private func fetchMarketNewsData() -> Observable<[MarketNews]> {
        self.isLoading.onNext(true)
        return Network.sharedInstance.performGetOnNews(stringUrl: ApiRoute.ROUTE_SERVER_NEWS.concat(string: ApiRoute.ROUTE_NEWS_CRYPTOCURRENCY))
    }
    
    func transform(input: Input) -> Output {
        
        let collectionViewDataSource = self.fetchMarketNewsData().do(onNext: { (market) in
            self.isLoading.onNext(false)
        })
        
        return Output(collectionViewDataSource: collectionViewDataSource, isLoading: self.isLoading)
    }
}
