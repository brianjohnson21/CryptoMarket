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
        let loaderTrigger: Driver<Bool>
        let quickSearchText: Driver<String?>
    }
    
    struct Output {
        let tableViewDataSource: Observable<[Market]>
        let isLoading: Observable<Bool>
        let quickSearchFound: Observable<[Market]>
    }
    
    private func fetchMarketData() -> Observable<[Market]> {
        return Network.sharedInstance.performGetOnMarket(stringUrl: ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_MARKET)).do(onNext: { (market) in
            self.isLoading.onNext(false)
        }, onError: nil, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
    }
    
    private func quickMarketSearch(query: String) -> Observable<[Market]> {
        return self.fetchMarketData().map { (market) -> [Market] in
            return market.filter { $0.name?.contains(query) ?? false}
        }
    }
    
    private func quickSearchText(quickText: Driver<String?>) -> Observable<[Market]> {
        return quickText.asSharedSequence()
            .asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.asyncInstance)
            .filter { $0?.isEmpty == false }
            .debounce(1, scheduler: MainScheduler.asyncInstance)
            .do(onNext: { (_) in
                self.isLoading.onNext(true)
            }).flatMapLatest({ (queryText) -> Observable<[Market]> in
                guard let textSearch = queryText else { return Observable.just([])}
                return self.quickMarketSearch(query: textSearch)
            })
    }
    
    func transform(input: Input) -> Output {
        
        let refreshDataSource = input.loaderTrigger.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.instance)
        .throttle(2.5, scheduler: MainScheduler.asyncInstance)
        .flatMapLatest({ (_) -> Observable<[Market]> in
            return self.fetchMarketData()
        })
        
        let tableDataSource = self.fetchMarketData().asObservable()
        
        let quickSearchFound = self.quickSearchText(quickText: input.quickSearchText)

        let tableViewDataSource = Observable.merge(tableDataSource, refreshDataSource, quickSearchFound).do(onNext: { (_) in
            self.isLoading.onNext(false)
        })
        
        return Output(tableViewDataSource: tableViewDataSource,
                      isLoading: self.isLoading.asObservable(),
                      quickSearchFound: quickSearchFound)
    }
}
