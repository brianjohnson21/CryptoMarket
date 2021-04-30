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
        let tableviewDataSources: Observable<[PortfolioCellProtocol]>
    }
    
    private func createInputOnCellPortfolio() -> [PortfolioCellProtocol] {
        var tableView: [PortfolioCellProtocol] = []
        
        tableView.append(InputCell(title: "Amount"))
        tableView.append(InputCell(title: "Price"))
        
        return tableView
    }
    
    func transform(input: Input) -> Output {
        let tableViewSource = self.createInputOnCellPortfolio()
        
        return Output(tableviewDataSources: Driver.just(tableViewSource).asObservable())
    }
}
