//
//  AddCryptoCellViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 03/05/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class AddCryptoCellViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let mainVM: AddCryptoViewModel
    
    struct Input {
        let onTap: Observable<(Market, Int)>
    }
    
    struct Output {
        
    }
    
    init(vm: AddCryptoViewModel) {
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
