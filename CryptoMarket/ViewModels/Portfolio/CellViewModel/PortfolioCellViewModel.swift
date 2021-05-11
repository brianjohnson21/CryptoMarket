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
    private let cellAmount: Double
    private let name: String
    
    init(with amount: Double, and crytpo: String) {
        self.cellAmount = amount
        self.name = crytpo
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
    
    private func fetchMarket() { }
    
    func transform(input: Input) -> Output {
        self.isLoading.onNext(true)
        
        let price = self.fetchMarketData().map { (market) -> Double in
            return market.map { (s1) -> Double in
                if s1.name ?? "" == self.name {
                    let usdPrice = Double(s1.priceUsd ?? "") ?? 0.0
                    let amount = self.cellAmount
                    return amount * usdPrice
                }
                return 0
            }.reduce(0, +)
        }
            
        return Output(percentage: price.asObservable(), price: price.asObservable())
    }
}
