//
//  AddMoneyCellViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 04/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class AddMoneyCellViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let mainVM: AddMoneyViewModel
    
    struct Input {
        let onTap: Observable<(MoneySelectedValue, Int)>
    }
    
    struct Output {
        
    }
    
    init(vm: AddMoneyViewModel) {
        self.mainVM = vm
    }
    
    func transform(input: Input) -> Output {
        input.onTap
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event, row) in
                self.mainVM.onCellTapDone(with: (event, row))
            }).disposed(by: self.disposeBag)
        
        return Output()
    }
}
