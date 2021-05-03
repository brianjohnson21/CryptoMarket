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
    struct Input {}
    
    struct Output {
        let tableviewDataSources: Observable<[Int: [PortfolioCellProtocol]]>
    }
    
    private func createInputOnCellPortfolio() -> [Int: [PortfolioCellProtocol]] {
        
        var tableViewInput: [PortfolioCellProtocol] = []
        var tableViewDate: [PortfolioCellProtocol] = []
        
        var dataTableView: [Int: [PortfolioCellProtocol]] = [:]
        
        tableViewInput.append(InputCell(title: "Amount"))
        tableViewInput.append(InputCell(title: "Price"))
        tableViewInput.append(InputCell(title: "Total"))
        tableViewInput.append(InputCell(title: "Fee"))
        
        tableViewDate.append(DateCell(title: "Date"))
        
        dataTableView[0] = tableViewInput
        dataTableView[1] = tableViewDate
        
        return dataTableView
    }
    
    func transform(input: Input) -> Output {
        let tableViewSource = self.createInputOnCellPortfolio()
        
        return Output(tableviewDataSources: Driver.just(tableViewSource).asObservable())
    }
}
