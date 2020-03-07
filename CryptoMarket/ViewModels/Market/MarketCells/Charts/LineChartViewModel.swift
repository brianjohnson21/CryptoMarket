//
//  LineChartViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 07/03/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class LineChartViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {}
    struct Output {}
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
