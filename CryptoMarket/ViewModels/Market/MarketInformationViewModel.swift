//
//  MarketInformationViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 23/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public final class MarketInformationViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let market: Market
    
    struct Input {}
    struct Output {
        let navigationTitle: String
        let tableViewDataSource: Driver<[CellViewModelProtocol]>
    }
    
    init(marketSelected: Market) {
        
        self.market = marketSelected
    }
    
    private func createChartCell() -> [CellViewModelProtocol] {
        var tableViewData: [CellViewModelProtocol] = []
        
        tableViewData.append(ChartCell(title: "GRAPHIQUE", detail: "THE GRAPHIQUE SHOULD BE DISPLAYED HERE"))
        return tableViewData
    }
    
    private func createTableInformationCell() -> [CellViewModelProtocol] {
        var tableViewData: [CellViewModelProtocol] = []
        
        tableViewData.append(InformationCell(title: "Rank", detail: "1"))
        tableViewData.append(InformationCell(title: "Market Cap", detail: "$131,462,930,153"))
        tableViewData.append(InformationCell(title: "VWAP (24H)", detail: "$7,268"))
        tableViewData.append(InformationCell(title: "Supply", detail: "18,095,525"))
        tableViewData.append(InformationCell(title: "Volume (24Hr)", detail: "$3,317,861,099"))
        tableViewData.append(InformationCell(title: "Change (24Hr)", detail: "1.38%"))
        
        return tableViewData
    }
    
    func transform(input: Input) -> Output {
        
        
        let tableViewDataSource = self.createChartCell() + self.createTableInformationCell()
        
        return Output(navigationTitle: self.market.name ?? "Market Chart", tableViewDataSource: Driver.just(tableViewDataSource))
    }
}
