//
//  MarketChartViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 22/12/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public enum chartLegendType: Int {
    case m1 = 0
    case m5
    case m15
    case m30
    case h1
    case h2
    case h6
    case h12
    case d1
}

public final class MarketChartViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let legendEvent: Driver<chartLegendType>
    }
    
    struct Output {
        
    }
    
    private func handleLegendEvent(elementSelected: chartLegendType) {
        print("will handle legend Event here... \(elementSelected.rawValue)")
    }
    
    func transform(input: Input) -> Output {
        
        input.legendEvent.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (legendSelected) in
                self.handleLegendEvent(elementSelected: legendSelected)
            }).disposed(by: self.disposeBag)
        
        
        
        return Output()
    }
    
}
