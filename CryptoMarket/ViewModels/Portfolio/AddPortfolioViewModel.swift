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
    
    private let onTapCellEvent: PublishSubject<(Market, Int)> = PublishSubject<(Market, Int)>()
    private let onCellTap: PublishSubject<Int> = PublishSubject<Int>()
    
    struct Input {
        
    }
    
    struct Output {
        let onTapCellEvent: Observable<(Market, Int)>
        let onSelectTap: Observable<Int>
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
    
    internal func onCellTap(with event: Market, with row: Int) {
        self.onTapCellEvent.onNext((event, row))
    }
    
    internal func onSelectTap(row selected: Int) {
        self.onCellTap.onNext(selected)
    }
    
    func transform(input: Input) -> Output {
        let tableViewSource = self.createInputOnCellPortfolio()
        
        return Output(onTapCellEvent: self.onTapCellEvent.asObservable(),
                      onSelectTap: self.onCellTap.asObservable(),
                      tableviewDataSources: Driver.just(tableViewSource).asObservable())
    }
}
