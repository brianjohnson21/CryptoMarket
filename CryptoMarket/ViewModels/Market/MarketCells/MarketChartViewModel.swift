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

public final class MarketChartViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let isChartLoading = BehaviorSubject<Bool>(value: false)
    private let chartId: String
    
    struct Input {
        let legendEvent: Observable<ApiInterval>
    }
    
    struct Output {
        let isChartLoading: Observable<Bool>
        let chartViewData: Observable<[ChartDataEntry]>
    }

    public init(chartId: String) {
        print("Showing the chart Id used here \(chartId)")
        self.chartId = chartId
    }
    
    private func handleLegendEvent(elementSelected: ApiInterval) {
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
    
    func transform(input: Input) -> Output {
        
        self.isChartLoading.onNext(false)
        
        let chartData: Observable<[ChartDataEntry]> = input.legendEvent.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .do(onNext: { (_) in
                self.isChartLoading.onNext(true)
            }).flatMap { (interval) -> Observable<[ChartDataEntry]> in
                return self.fetchDataEntries(assetName: self.chartId, interval: interval)
            }.do(onNext: { (_) in
                self.isChartLoading.onNext(false)
            })
        
        return Output(isChartLoading: self.isChartLoading.asObservable(), chartViewData: chartData)
    }
    
}
