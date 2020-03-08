//
//  pieChartViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 08/03/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Charts

internal final class PieChartViewModel: ViewModelType {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private func fetchFeerAndGreed() -> Observable<[MarketEmotion]> {
        return Network.sharedInstance.performGetOnFeerAndGred(string: ApiRoute.ROUTE_SERVER_FEER.concat(string: ApiRoute.ROUTE_FEER_GREED))
    }
    
    func transform(input: Input) -> Output {
        let res = self.fetchFeerAndGreed().subscribe(onNext: { (result) in
            print("[TRANSFORM] = \(result)")
        }).disposed(by: self.disposeBag)
        
        return Output()
    }
}
