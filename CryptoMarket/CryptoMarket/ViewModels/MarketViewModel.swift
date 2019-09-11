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
    }
    
    struct Output {
        let tableViewDataSource: Observable<[String]>
    }

    private func createTableViewDataSource() -> [String] {
        var tableViewData: [String] = []
        for index in 0...10 {
            tableViewData.append("Yolo \(index)")
        }
        return tableViewData
    }
    
    func transform(input: Input) -> Output {
        
        let tableViewDataSource: Observable<[String]> = Observable.just(self.createTableViewDataSource())
        
        return Output(tableViewDataSource: tableViewDataSource)
        
    }
}
