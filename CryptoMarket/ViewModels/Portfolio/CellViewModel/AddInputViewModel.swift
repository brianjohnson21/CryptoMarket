//
//  AddInputViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 03/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class AddInputViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let mainVM: AddPortfolioViewModel
    private let behave: PublishSubject<Double> = PublishSubject<Double>()
    private let row: Int
    
    struct Input {
        let onSelectCrypto: Observable<Int>
        let onSelectMonyey: Observable<Int>
        let moneyAmount: Observable<(Int, Double)>
    }
    
    struct Output {
        let updateCellsValue: Observable<Double>
    }
    
    init(vm: AddPortfolioViewModel, with row: Int) {
        self.mainVM = vm
        self.row = row
    }
    
    func transform(input: Input) -> Output {
        input.onSelectCrypto
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { row in
                self.mainVM.onSelectCryptoEvent(row: row)
            }).disposed(by: self.disposeBag)
        
        input.moneyAmount
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                self.mainVM.onValueSet(with: (self.row, value.1))
            }).disposed(by: self.disposeBag)
        
        input.onSelectMonyey
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { row in
                self.mainVM.onSelectMoneyEvent(row: row)
            }).disposed(by: self.disposeBag)
        
        self.mainVM.onInputCellUpdate
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                let needChangeRow = value.0
                let currentRowTyped = value.2
                let newValue = value.1
                if needChangeRow == self.row && self.row != currentRowTyped {
                    self.behave.onNext(newValue)
                }
            }).disposed(by: self.disposeBag)
        
        
        return Output(updateCellsValue: self.behave.asObservable())
    }
}
