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
        let legendEvent: Observable<ChartLegend>
    }
    
    struct Output {
        let isChartLoading: Observable<Bool>
        let chartViewData: Observable<[ChartDataEntry]>
    }

    public init(chartId: String) {
        self.chartId = chartId
    }
    
    private func createHistoryDate(legendSelected: ChartLegend) -> MarketHistoryRequest {
        let currentTime = Date().millisecondsSince1970

        switch legendSelected {
        case .day:
            return MarketHistoryRequest(startDate: "\(Calendar.current.date(byAdding: .day, value: -1, to: Date())?.millisecondsSince1970 ?? currentTime)", endDate: "\(currentTime)", inteval: .m5)
        case .week:
            return MarketHistoryRequest(startDate: "\(Calendar.current.date(byAdding: .day, value: -7, to: Date())?.millisecondsSince1970 ?? currentTime)", endDate: "\(currentTime)", inteval: .m30)
        case .month:
            return MarketHistoryRequest(startDate: "\(Calendar.current.date(byAdding: .day, value: -30, to: Date())?.millisecondsSince1970 ?? currentTime)", endDate: "\(currentTime)",inteval: .h1)
        case .year:
            return MarketHistoryRequest(startDate: "\(Calendar.current.date(byAdding: .year, value: -1, to: Date())?.millisecondsSince1970 ?? currentTime)", endDate: "\(currentTime)" ,inteval: .d1)
        case .all:
            return MarketHistoryRequest(startDate: "", endDate: "", inteval: .d1)
        }
    }
    
    private func fetchHistoryData(assetName name: String, legendSelected: ChartLegend) -> Observable<[MarketInformation]> {
        
        return Network.sharedInstance.performGetOnHistory(stringUrl: ApiRoute.ROUTE_SERVER_MARKET.concat(string: ApiRoute.ROUTE_HISTORY), assetName: name, legendData: self.createHistoryDate(legendSelected: legendSelected)).asObservable()
    }
    
    private func fetchDataEntries(assetName: String, interval: ChartLegend) -> Observable<[ChartDataEntry]> {
        
        self.fetchHistoryData(assetName: assetName, legendSelected: interval)
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
