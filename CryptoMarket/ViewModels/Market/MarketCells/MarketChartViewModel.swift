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
    private let chartId: String
    
    struct Input {
        let legendEvent: PublishSubject<chartLegendType>
    }
    
    struct Output {
        let isChartLoading: Observable<Bool>
        let chartViewData: Observable<[ChartDataEntry]>
    }

    public init(chartId: String) {
        self.chartId = chartId
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
    
    func transform(input: Input) -> Output {
        
        self.isChartLoading.onNext(false)
        
        let chartData: Observable<[ChartDataEntry]> = input.legendEvent.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .do(onNext: { (_) in
                self.isChartLoading.onNext(true)
            }).flatMap { (legend) -> Observable<[ChartDataEntry]> in                
                var api: ApiInterval = .d1
                
                switch legend {
                case .d1:
                    api = .d1
                case .m5:
                    api = .m5
                case .m15:
                    api = .m15
                case .m30:
                    api = .m30
                case .h1:
                    api = .h1
                case .h2:
                    api = .h2
                case .h6:
                    api = .h6
                case .h12:
                    api = .h12
                case .m1:
                    api = .m1
                }
                
                return self.fetchDataEntries(assetName: self.chartId, interval: api)
            }.do(onNext: { (_) in
                self.isChartLoading.onNext(false)
            })
        
        return Output(isChartLoading: self.isChartLoading.asObservable(), chartViewData: chartData)
    }
    
}
