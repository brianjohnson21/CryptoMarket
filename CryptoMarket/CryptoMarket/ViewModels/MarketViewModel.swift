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
        let onAdd: Driver<Void>
    }
    
    struct Output {
    }

    func transform(input: Input) -> Output {
        
        input.onAdd.asObservable()
        .subscribeOn(MainScheduler.asyncInstance)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { (_) in
            print("React to Tap")
        }).disposed(by: self.disposeBag)
        
        
        return Output()
    }
}
