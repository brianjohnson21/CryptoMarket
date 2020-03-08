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
    
    private let lineChartName: String
    private let lineChartPercentage: String

    internal init(lineChartName: String, lineChartPercentage: String) {
        self.lineChartName = lineChartName
        self.lineChartPercentage = lineChartPercentage
    }
    
    struct Input {}
    
    struct Output {
        let chartsView: Driver<[UIView]>
    }
    
    private func generateChartsView() -> [UIView] {
        var diagram: [UIView] = []
        
        if let lineChart: LineChart = Bundle.main.loadNibNamed(LineChart.identifier, owner: nil, options: nil)?.first as? LineChart {
            lineChart.setup(assetName: self.lineChartName, assetPercentage: self.lineChartPercentage)
            diagram.append(lineChart)
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
