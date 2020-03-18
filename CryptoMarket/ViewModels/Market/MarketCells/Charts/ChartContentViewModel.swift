//
//  ChartContentViewModel.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 08/02/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

internal final class ContentChartViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    private let lineChartMarket: Market?

    internal init(lineChartMarket: Market?) {
        self.lineChartMarket = lineChartMarket
    }
    
    struct Input {}
    
    struct Output {
        let chartsView: Driver<[UIView]>
    }
    
    private func generateChartsView() -> [UIView] {
        var diagram: [UIView] = []
        
        if let lineChart: LineChart = Bundle.main.loadNibNamed(LineChart.identifier, owner: nil, options: nil)?.first as? LineChart {
            lineChart.setup(assetName: self.lineChartMarket?.id ?? "", assetPercentage: self.lineChartMarket?.changePercent24Hr ?? "", currencyPrice: self.lineChartMarket?.priceUsd?.currencyFormatting(formatterDigit: 2) ?? "")
            diagram.append(lineChart)
        }
        
        if let lineChartFear: LineChartFear = Bundle.main.loadNibNamed(LineChartFear.identifier, owner: nil, options: nil)?.first as? LineChartFear {
            lineChartFear.setup()
            diagram.append(lineChartFear)
        }
        
        if let pieDiagram: PieChart = Bundle.main.loadNibNamed(PieChart.identifier, owner: nil, options: nil)?.first as? PieChart {
            pieDiagram.setup()
            diagram.append(pieDiagram)
        }
        
        return diagram
    }
    
    func transform(input: Input) -> Output {
        return Output(chartsView: Driver.just(self.generateChartsView()))
    }
}
