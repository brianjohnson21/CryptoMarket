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
    private let isLoading = PublishSubject<Bool>()
    
    struct Input {
        let loaderTrigger: Observable<Bool>
    }
    
    struct Output {
        let tableViewDataSource: Observable<[Market]>
        let isLoading: Observable<Bool>
    }
    
    private func fetchMarketData() -> Observable<[Market]> {
        return Network.sharedInstance.perfromGetRequest(stringUrl: ApiRoute.ROUTE_SERVER.concat(string: ApiRoute.ROUTE_MARKET)).do(onNext: { (market) in
            self.isLoading.onNext(false)
        }, onError: nil, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
    }
    
    func transform(input: Input) -> Output {
        
        let refreshDataSource = input.loaderTrigger.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .throttle(2.5, scheduler: MainScheduler.asyncInstance)
        .flatMapLatest({ (_) -> Observable<[Market]> in
            return self.fetchMarketData()
        })
        
        let tableDataSource: Observable<[Market]> = self.fetchMarketData().asObservable()
        
        let tableViewDataSource = Observable.merge(tableDataSource, refreshDataSource)

        return Output(tableViewDataSource: tableViewDataSource,
                      isLoading: self.isLoading.asObservable())
    }
}
