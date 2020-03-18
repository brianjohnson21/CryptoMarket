//
//  pieChartViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 08/03/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Charts

internal final class PieChartViewModel: ViewModelType {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    struct Input { }
    
    struct Output {
        let marketEmotion: Observable<[MarketEmotion]>
        let pieViewData: Observable<([PieChartDataEntry], UIColor)>
    }
    
    private func fetchFeerAndGreed() -> Observable<[MarketEmotion]> {
        return Network.sharedInstance.performGetMarketEmotions(stringUrl: ApiRoute.ROUTE_SERVER_FEER.concat(string: ApiRoute.ROUTE_FEER_GREED))
    }
    
    private func fetchDataEntries() -> Observable<[PieChartDataEntry]> {
        
        return self.fetchFeerAndGreed().asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .map { (marketInformation) -> [PieChartDataEntry] in
                var result: [PieChartDataEntry] = []
                for element in marketInformation {
                    result.append(PieChartDataEntry(value: Double(element.value ?? "0") ?? 0, label: "\(element.value_classification ?? "None")"))
                }
                
                ///<-> Add default case for the pieChart x/100%
                ///Mark: This might be used later but seems useless for now 🤔
                ///result.append(PieChartDataEntry(value: (100 - (result.last?.value ?? 0)), label: ""))
                
                return result
            }
    }
    
    func transform(input: Input) -> Output {
        
        let chartData: Observable<[PieChartDataEntry]> = self.fetchDataEntries()
        
        
        let chartResult: Observable<([PieChartDataEntry], UIColor)> = chartData.map { (data) -> ([PieChartDataEntry], UIColor) in
            switch (data.first?.value ?? 0) {
            case let fear where fear <= 30:
                return (data, UIColor.init(named: "SortDown") ?? UIColor.white)
            case let fear where fear > 30 && fear < 70:
                return (data, UIColor.init(named: "SecondaryColor") ?? UIColor.white)
            case let fear where fear >= 70:
                return (data, UIColor.init(named: "SortUp") ?? UIColor.white)
            default:
                return (data, UIColor.white)
            }
        }
        
        return Output(marketEmotion: self.fetchFeerAndGreed(), pieViewData: chartResult)
    }
}
