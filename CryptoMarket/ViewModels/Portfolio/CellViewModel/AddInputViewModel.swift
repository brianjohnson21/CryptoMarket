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
    
    struct Input {
        let onTap: Observable<Int>
    }
    
    struct Output {
        
    }
    
    init(vm: AddPortfolioViewModel) {
        self.mainVM = vm
    }
    
    func transform(input: Input) -> Output {
        input.onTap
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { row in
                self.mainVM.onSelectTap(row: row)
            }).disposed(by: self.disposeBag)
        
        return Output()
    }
}
