//
//  MarketChartViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 22/12/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Charts

public enum chartLegendType: Int {
    case m1 = 0
    case m5
    case m15
    case m30
    case h1
    case h2
    case h6
    case h12
    case d1
}

public final class MarketChartViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let isChartLoading = BehaviorSubject<Bool>(value: false)
    
    struct Input {
        let legendEvent: Observable<chartLegendType>
        
    }
    
    struct Output {
        let chartData: [ChartDataEntry]
        let isChartLoading: Observable<Bool>
        let chartViewData: Observable<[ChartDataEntry]>
    }
    
    private func handleLegendEvent(elementSelected: chartLegendType) {
        print("will handle legend Event here... \(elementSelected.rawValue)")
    }
    
    private func fetchHistoryData(assetName name: String, interval: ApiInterval) -> Observable<[MarketInformation]> {
        return Network.sharedInstance.performGetOnHistory(stringUrl: ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_HISTORY), assetName: name, interval: interval).asObservable()
    }
    
    private func fetchDataEntries(assetName: String, interval: ApiInterval) -> Observable<[ChartDataEntry]> {
        
        self.fetchHistoryData(assetName: assetName, interval: interval)
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .map({ (marketInformation) -> [ChartDataEntry] in
                var result: [ChartDataEntry] = []
                for (index, element) in marketInformation.enumerated() {
                    result.append(ChartDataEntry(x: Double(index), y: Double(element.priceUsd ?? "0") ?? 0.0))
                }
                return result
            })
    }
    
    private func getData() {
        
        Network.sharedInstance.performGetOnHistory(stringUrl: ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_HISTORY), assetName: "bitcoin", interval: .d1)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (marketInformation) in
                print(marketInformation)
            }).disposed(by: self.disposeBag)
    }
    
    private func getDataEntries() -> [ChartDataEntry] {
        
        var val = [ChartDataEntry]()
        
        val.append(ChartDataEntry(x: 1, y: 1000))
        val.append(ChartDataEntry(x: 2, y: 6000))
        val.append(ChartDataEntry(x: 3, y: 2000))
        val.append(ChartDataEntry(x: 4, y: 7000))
        val.append(ChartDataEntry(x: 5, y: 7500))
        val.append(ChartDataEntry(x: 6, y: 8000))
        val.append(ChartDataEntry(x: 7, y: 3000))
        val.append(ChartDataEntry(x: 8, y: 3500))
        val.append(ChartDataEntry(x: 9, y: 9500))
        val.append(ChartDataEntry(x: 10, y: 10000))
        val.append(ChartDataEntry(x: 11, y: 10500))
        val.append(ChartDataEntry(x: 12, y: 11000))
        val.append(ChartDataEntry(x: 13, y: 2000))
        val.append(ChartDataEntry(x: 14, y: 12000))
        val.append(ChartDataEntry(x: 15, y: 30000))
        val.append(ChartDataEntry(x: 16, y: 13000))
        
        return val
    }
    
    func transform(input: Input) -> Output {
        
        self.isChartLoading.onNext(false)
        
        input.legendEvent.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (legendSelected) in
                self.handleLegendEvent(elementSelected: legendSelected)
            }).disposed(by: self.disposeBag)
        
        let chartResult = self.fetchDataEntries(assetName: "bitcoin", interval: .d1)
                
        return Output(chartData: self.getDataEntries(), isChartLoading: self.isChartLoading.asObservable(), chartViewData: self.fetchDataEntries(assetName: "bitcoin", interval: .d1))
    }
    
}
