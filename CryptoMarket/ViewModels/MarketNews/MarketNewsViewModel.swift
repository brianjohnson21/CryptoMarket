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

public final class MarketNewsViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {}
    struct Output {}
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
