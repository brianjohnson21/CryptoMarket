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
    struct Output {
        let collectionViewDataSource: Observable<[String]>
    }
    
    private func fetchNewsData() -> Observable<[String]> {
        return Observable.create { (observer) -> Disposable in
            var tableFakeData: [String] = []
            for index in 1...20 {
                tableFakeData.append("fake collection view \(index)")
            }
            observer.onNext(tableFakeData)
            return Disposables.create()
        }
    }
    
    func transform(input: Input) -> Output {
        
        let collectionViewDataSource = self.fetchNewsData()
        
        return Output(collectionViewDataSource: collectionViewDataSource)
    }
}
