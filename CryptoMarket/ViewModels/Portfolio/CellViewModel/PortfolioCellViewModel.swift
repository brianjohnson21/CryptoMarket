//
//  PortfolioCellViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 11/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class PortfolioCellViewModel: ViewModelType {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
    private let portfolioValue: PortfolioCore
    
    init(with portoflio: PortfolioCore) {
        self.portfolioValue = portoflio
    }
    
    struct Input { }
    
    struct Output {
        let percentage: Observable<Double>
        let price: Observable<Double>
    }
    
    private func fetchMarketData() -> Observable<[Market]> {
        return Network.sharedInstance.performGetOnMarket(stringUrl: ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_MARKET)).do(onNext: { (market) in
            self.isLoading.onNext(false)
        })
    }
    
    private func fetchCurrentMarket(market name: String) -> Observable<Market> {
        let route = ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_MARKET)
        return Network.sharedInstance.performGetOnMarket(stringUrl: route, with: name).do(onNext: { _ in
            self.isLoading.onNext(false)
        })
    }
    
    private func fetchMarket() { }
    
    func transform(input: Input) -> Output {
        self.isLoading.onNext(true)
        
        let market = self.fetchCurrentMarket(market: self.portfolioValue.marketName ?? "")
        
        let price = market.map { (market) -> Double in
            let usdPrice = Double(market.priceUsd ?? "0") ?? 0.0
            let amount = Double(self.portfolioValue.amount ?? "0") ?? 0.0
            print("SHOWING THERE = \(market)")
            return amount * usdPrice
        }
        
        let percentage = market.map { (market) -> Double in
            let percentage = Double(market.priceUsd ?? "0") ?? 0.0
            let total = Double(self.portfolioValue.total ?? "0") ?? 0.0
            print("SHOWING PERCENTAGE = \(percentage) \(self.portfolioValue.total)")
            let result = (percentage * total) / 100
            print("SHOWING RESULT = \(result)")
            return (percentage * total) / 100
        }
            
        return Output(percentage: percentage.asObservable(), price: price.asObservable())
    }
}
