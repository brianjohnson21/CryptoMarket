//
//  LineChartEmotionsViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 18/03/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Charts

internal final class LineChartEmotionsViewModel: ViewModelType {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let isChartLoading = BehaviorSubject<Bool>(value: false)
    
    struct Input {
        let legendEvent: Observable<ChartLegend>
    }
    
    struct Output {
        let chartViewData: Observable<[ChartDataEntry]>
        let isChartLoading: Observable<Bool>
    }
    
    internal enum ChartLegend: Int {
        case week = 7
        case month = 30
        case year = 365
        case all = 0
    }
    
    private func fetchMarketEmotions(interval: ChartLegend) -> Observable<[MarketEmotion]> {
        return Network.sharedInstance.performGetMarketEmotions(stringUrl: ApiRoute.ROUTE_SERVER_FEER.concat(string: ApiRoute.ROUTE_FEER_GREED), with: ApiEmotionsInterval(rawValue: interval.rawValue) ?? .week)
    }
    
    private func fetchChartData(interval: ChartLegend) -> Observable<[ChartDataEntry]> {
        self.fetchMarketEmotions(interval: interval)
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .map({ (market) -> [ChartDataEntry] in
                var result: [ChartDataEntry] = []
                
                for(index, element) in market.enumerated() {
                    result.append(ChartDataEntry(x: Double(index), y: Double(element.value ?? "0") ?? 0))
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
                return self.fetchChartData(interval: interval)
            }.do(onNext: { (_) in
            self.isChartLoading.onNext(false)
            })
        
        return Output(chartViewData: chartData,
                      isChartLoading: self.isChartLoading.asObservable())
    }
}
