//
//  LineChartFear.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 17/03/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import Charts

final class LineChartFear: UIView {
    
    @IBOutlet private weak var lineChart: LineChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //method called outside to setup
    public func setup() {
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.setChartSettings()
    }
    
    private func setupViewModel() {
        var chart: [ChartDataEntry] = []
        chart.append(ChartDataEntry(x: 0, y: 10))
        chart.append(ChartDataEntry(x: 1, y: 5))
        chart.append(ChartDataEntry(x: 2, y: 20))
        chart.append(ChartDataEntry(x: 3, y: 30))
        chart.append(ChartDataEntry(x: 4, y: 20))
        
        self.setupChartViewData(chartData: chart)
    }
    
    private func setChartSettings() {
        self.lineChart.chartDescription?.enabled = false
        self.lineChart.dragEnabled = false
        self.lineChart.legend.enabled = false
           
        self.lineChart.leftAxis.enabled = false
        self.lineChart.rightAxis.enabled = false
        
        self.lineChart.xAxis.enabled = false
        self.lineChart.animate(xAxisDuration: 1)
        self.lineChart.pinchZoomEnabled = false
    }
    
    private func setupChartViewData(chartData: [ChartDataEntry]) {
        let chartViewData = LineChartDataSet(entries: chartData)
        chartViewData.drawIconsEnabled = false
        
        chartViewData.setColor(UIColor.init(named: "White") ?? .red)
        chartViewData.lineWidth = 1.0
        //chartViewData.circleRadius = 0.0
        chartViewData.drawValuesEnabled = true
        chartViewData.drawFilledEnabled = false
        
        chartViewData.fillAlpha = 1
        chartViewData.fill = Fill(linearGradient: getGradientChartViewBackground(), angle: 90)
        chartViewData.drawFilledEnabled = true
        
        chartViewData.valueTextColor = .white
        
        let setDataOnChart = LineChartData(dataSet: chartViewData)
        
        self.lineChart.data = setDataOnChart
        self.lineChart.animate(xAxisDuration: 0.2)
    }
    
    private func getGradientChartViewBackground() -> CGGradient {
        let gradientColors = [UIColor.init(named: "Color-3")?.cgColor, UIColor.init(named: "Color")?.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        return gradient
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
