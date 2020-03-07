//
//  InformationCellProtocol.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 24/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import Foundation

internal enum CellViewModelType: String {
    case Chart
    case Detail
}

internal enum ChartViewModelType: String {
    case LineChart
    case CircleChart
}

internal protocol ChartViewModelProtocol {
    //type of the chart that needs to be displayed
    var chartType: ChartViewModelType { get }
}

internal protocol CellViewModelProtocol {
    //type of the cell that needs to be displayed
    var type: CellViewModelType { get }
    //used as the title of a section, doesn't necessary have one..
    var title: String? { get }
}

internal final class LineChartCell: ChartViewModelProtocol {
    var title: String?
    var market: Market

    var chartType: ChartViewModelType {
        return .LineChart
    }
    
    init(title: String?, market: Market) {
        self.title = title
        self.market = market
    }
}

internal final class CircleChartCell: ChartViewModelProtocol {
    var title: String?
    var data: String
    
    var chartType: ChartViewModelType {
        return .CircleChart
    }
    
    init(title: String?, data: String) {
        self.title = title
        self.data = data
    }
}

internal final class ChartContentCell: CellViewModelProtocol {
    var title: String?
    var lineChart: LineChartCell?
    var circleChart: CircleChartCell?
    
    var type: CellViewModelType {
        return .Chart
    }
    
    init(title: String?, lineChart: LineChartCell?, circleChart: CircleChartCell?) {
        self.title = title
        self.lineChart = lineChart
        self.circleChart = circleChart
    }
}

internal final class InformationCell: CellViewModelProtocol {
    var title: String?
    var isOpen: Bool
    var items: [Int: (String, String)]
    
    var type: CellViewModelType {
        return .Detail
    }
    
    init(title: String?, items: [Int: (String, String)], isOpen: Bool) {
        self.title = title
        self.isOpen = isOpen
        self.items = items
    }
}
