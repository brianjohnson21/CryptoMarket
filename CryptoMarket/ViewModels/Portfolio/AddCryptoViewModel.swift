//
//  AddCryptoViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 03/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal class AddCryptoViewModel: ViewModelType {
    private let mainVM: AddPortfolioViewModel
    private let done: PublishSubject<(Market, Int)> = PublishSubject<(Market, Int)>()
    private let disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let onCryptoEvent: Observable<(Market, Int)>
    }
    
    struct Output {
        let onEventDone: Observable<(Market, Int)>
    }
    
    init(vm: AddPortfolioViewModel) {
        self.mainVM = vm
    }
    
    internal func onCellTapDone(with event: (Market, Int)) {
        self.done.onNext(event)
    }
    
    func transform(input: Input) -> Output {
        input.onCryptoEvent
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { event in
                self.mainVM.onCellTap(with: event.0, with: event.1)
            }).disposed(by: self.disposeBag)
        
        return Output(onEventDone: self.done.asObservable())
    }
}
