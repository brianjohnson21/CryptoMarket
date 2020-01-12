//
//  MarketInformationViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 23/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreData

internal enum MarketInformationFlowType {
    case favorite
    case market
}

public final class MarketInformationViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let market: Market
    
    struct Input {
        let favoriteEvent: Observable<Void>
        let imageName: Driver<String>
    }
    
    struct Output {
        let navigationTitle: String
        let tableViewDataSource: Driver<[CellViewModelProtocol]>
        let imageDownloaded: Observable<UIImage?>
    }
    
    init(marketSelected: Market) {
        self.market = marketSelected
    }
    
    private func createChartCell() -> [CellViewModelProtocol] {
        var tableViewData: [CellViewModelProtocol] = []
        
        tableViewData.append(ChartCell(title: nil, market: self.market))
        
        return tableViewData
    }
    
    private func createTableInformationCell() -> [CellViewModelProtocol] {
        var tableViewData: [CellViewModelProtocol] = []
        
        var dataTableView: [Int: (String, String)] = [:]
    
        dataTableView[0] = ("Rank", self.market.rank ?? "")
        dataTableView[1] = ("Market Cap", self.market.marketCapUsd?.currencyFormatting(formatterDigit: 0) ?? "")
        dataTableView[2] = ("VWAP (24H)", self.market.vwap24Hr?.currencyFormatting(formatterDigit: 0) ?? "")
        dataTableView[3] = ("Supply", self.market.supply?.numberFormatting(formatterDigit: 0, isDecimal: true) ?? "")
        dataTableView[4] = ("Volume (24Hr)", self.market.volumeUsd24Hr?.currencyFormatting(formatterDigit: 0) ?? "")
        dataTableView[5] = ("Change (24Hr)", self.market.changePercent24Hr?.percentageFormatting() ?? "")
                
        tableViewData.append(InformationCell(title: "Coin Statistics", items: dataTableView, isOpen: true))
        
        return tableViewData
    }
        
    private func createFavorite() {
        CoreDataManager.sharedInstance.create(with: self.market)
    }
    
    private func fetchImageFromString(pathImage name: String) -> Observable<UIImage?> {
        return Network.sharedInstance.performGetRequestImage(imageUrl: name)
    }
    
    func transform(input: Input) -> Output {
        let tableViewDataSource = self.createChartCell() + self.createTableInformationCell()
        
        input.favoriteEvent.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (_) in
                self.createFavorite()
            }).disposed(by: self.disposeBag)
        
        let image = input.imageName.asObservable()
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(MainScheduler.instance)
            .flatMap { (imageName) -> Observable<UIImage?> in
                return self.fetchImageFromString(pathImage: imageName)}
        
        return Output(navigationTitle: self.market.name ?? "Market Chart",
                      tableViewDataSource: Driver.just(tableViewDataSource),
                      imageDownloaded: image)
    }
}
