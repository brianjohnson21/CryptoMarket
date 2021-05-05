//
//  AddPortfolioViewModel.swift
//  CryptoMarket
//
//  Created by Thomas on 29/04/2021.
//  Copyright © 2021 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal class AddPortfolioViewModel: ViewModelType {
    
    private let onCryptoItemSelected: PublishSubject<(Market, Int)> = PublishSubject<(Market, Int)>()
    private let onMoneyItemSelected: PublishSubject<(MoneyModel, Int)> = PublishSubject<(MoneyModel, Int)>()
    
    private let onCryptoCellTapEvent: PublishSubject<Int> = PublishSubject<Int>()
    private let onMoneyCellTapEvent: PublishSubject<Int> = PublishSubject<Int>()
    
    struct Input { }
    
    struct Output {
        let onCryptoItemSelected: Observable<(Market, Int)>
        let onMoneyItemSelected: Observable<(MoneyModel, Int)>
        
        let onCryptoSelectEvent: Observable<Int>
        let onMoneySelectEvent: Observable<Int>
        let tableviewDataSources: Observable<[Int: [PortfolioCellProtocol]]>
    }
    
    private func createInputOnCellPortfolio() -> [Int: [PortfolioCellProtocol]] {
        
        var tableViewInput: [PortfolioCellProtocol] = []
        var tableViewDate: [PortfolioCellProtocol] = []
        
        var dataTableView: [Int: [PortfolioCellProtocol]] = [:]
        
        tableViewInput.append(InputCell(title: "Amount", button: nil, isCrypto: true))
        tableViewInput.append(InputCell(title: "Price", button: nil, isCrypto: false))
        tableViewInput.append(InputCell(title: "Total", button: nil, isCrypto: false))
        tableViewInput.append(InputCell(title: "Fee", button: nil, isCrypto: false))
        
        tableViewDate.append(DateCell(title: "Date"))
        
        dataTableView[0] = tableViewInput
        dataTableView[1] = tableViewDate
        
        return dataTableView
    }
    
    internal func onCryptoCellEvent(with event: Market, with row: Int) {
        self.onCryptoItemSelected.onNext((event, row))
    }
    
    internal func onMoneyCellEvent(with event: MoneyModel, with row: Int) {
        self.onMoneyItemSelected.onNext((event, row))
    }
    
    internal func onSelectCryptoEvent(row selected: Int) {
        self.onCryptoCellTapEvent.onNext(selected)
    }
    
    internal func onSelectMoneyEvent(row selected: Int) {
        self.onMoneyCellTapEvent.onNext(selected)
    }

    func transform(input: Input) -> Output {
        let tableViewSource = self.createInputOnCellPortfolio()
        
        return Output(onCryptoItemSelected: self.onCryptoItemSelected.asObservable(),
                      onMoneyItemSelected: self.onMoneyItemSelected.asObservable(),
                      onCryptoSelectEvent: self.onCryptoCellTapEvent.asObservable(),
                      onMoneySelectEvent: self.onMoneyCellTapEvent.asObservable(),
                      tableviewDataSources: Driver.just(tableViewSource).asObservable())
    }
}
