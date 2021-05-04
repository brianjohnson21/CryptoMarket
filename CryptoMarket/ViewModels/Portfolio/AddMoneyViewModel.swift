//
//  AddMoneyViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 04/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public enum MoneySelectedValue: String {
    case USD
    case EURO
}

internal class AddMoneyViewModel: ViewModelType {
    
    private let mainVM: AddPortfolioViewModel
    private let done: PublishSubject<(MoneySelectedValue, Int)> = PublishSubject<(MoneySelectedValue, Int)>()
    private let disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let onMoneyEvent: Observable<(MoneySelectedValue, Int)>
    }
    
    struct Output {
        let onEventDone: Observable<(MoneySelectedValue, Int)>
    }
    
    init(vm: AddPortfolioViewModel) {
        self.mainVM = vm
    }
    
    internal func onCellTapDone(with event: (MoneySelectedValue, Int)) {
        self.done.onNext(event)
    }
    
    func transform(input: Input) -> Output {
        input.onMoneyEvent
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { event in
                self.mainVM.onMoneyCellEvent(with: event.0 , with: event.1)
            }).disposed(by: self.disposeBag)
        
        return Output(onEventDone: self.done.asObservable())
    }
}
