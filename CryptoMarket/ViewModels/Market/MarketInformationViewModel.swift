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
        
        tableViewData.append(InformationCell(title: "INFORMATIONS", detail: "INFORMATION SHOULD BE DISPLAYED HERE"))
        return tableViewData
    }
    
    func transform(input: Input) -> Output {
        
        
        let tableViewDataSource = self.createChartCell() + self.createTableInformationCell()
        
        return Output(navigationTitle: self.market.name ?? "Market Chart", tableViewDataSource: Driver.just(tableViewDataSource))
    }
}
