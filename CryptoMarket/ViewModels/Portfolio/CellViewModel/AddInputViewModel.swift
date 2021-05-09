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
    private let row: Int
    
    struct Input {
        let onSelectCrypto: Observable<Int>
        let onSelectMonyey: Observable<Int>
        let moneyAmount: Observable<Double>
    }
    
    struct Output {
        
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
            .subscribe(onNext: { textFieldValue in
                self.mainVM.onValueSet(with: (self.row, textFieldValue))
            }).disposed(by: self.disposeBag)
        
        input.onSelectMonyey
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { row in
                self.mainVM.onSelectMoneyEvent(row: row)
            }).disposed(by: self.disposeBag)
        
        return Output()
    }
}
