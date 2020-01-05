//
//  FavoriteViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 05/01/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class FavoriteViewModel: ViewModelType {
    
    private let isLoading = PublishSubject<Bool>()
    
    struct Input {
    }
    
    struct Output {
        let favoriteMarket: Observable<[Market]>
        let isLoading: Observable<Bool>
    }
    
    private func fetchMarketData() -> Observable<[Market]> {
         return Network.sharedInstance.performGetOnMarket(stringUrl: ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_MARKET)).do(onNext: { (market) in
             self.isLoading.onNext(false)
         })
     }
    
    func transform(input: Input) -> Output {
        
        let favoriteMarket = self.fetchMarketData()
        
        return Output(favoriteMarket: favoriteMarket,
                      isLoading: self.isLoading.asObservable())
    }
}
