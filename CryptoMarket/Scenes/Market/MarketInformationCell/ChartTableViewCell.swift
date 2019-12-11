//
//  ChartTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 24/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import SwiftChart

import Charts

class ChartTableViewCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet private weak var labelPrice: UILabel!
    @IBOutlet private weak var labelPercentage: UILabel!
    @IBOutlet private weak var imageSort: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    
    private var tagButtonSelected = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        (self.viewWithTag(self.tagButtonSelected) as? UIButton)?.isSelected = true
        self.addHighlight(buttonTag: self.tagButtonSelected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func addHighlight(buttonTag tag: Int) {
        guard let button = (self.viewWithTag(tag) as? UIButton) else { return }
        
        button.backgroundColor = UIColor.init(named: "Color-1")
        button.layer.cornerRadius = 4.0
    }
    
    private func removeHighlight(buttonTag tag: Int) {
        guard let button = (self.viewWithTag(tag) as? UIButton) else { return }
        
        button.backgroundColor = UIColor.init(named: "MainColor")
        button.layer.cornerRadius = 0.0
    }
    
    @IBAction private func legendOneTapped(_ sender: UIButton) {
        
        let oldSender = (self.viewWithTag(tagButtonSelected) as? UIButton)
        oldSender?.isSelected = false
        self.removeHighlight(buttonTag: self.tagButtonSelected)
        
        self.tagButtonSelected = sender.tag
        self.addHighlight(buttonTag: sender.tag)
        sender.isSelected = true
    }
    
    public func setupChart() {

        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.legend.enabled = false
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.enabled = false
        chartView.animate(xAxisDuration: 1)

        self.setupChartViewData()
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
    
    private func getGradientChartViewBackground() -> CGGradient {
        let gradientColors = [UIColor.init(named: "Color-3")?.cgColor, UIColor.init(named: "Color")?.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        return gradient
    }
    
    private func setupChartViewData() {
        let chartViewData = LineChartDataSet(entries: self.getDataEntries(), label: "")
        chartViewData.drawIconsEnabled = false
        
        chartViewData.setColor(UIColor.init(named: "Color-1") ?? .red)
        
        chartViewData.lineWidth = 2.0
        chartViewData.circleRadius = 0.0
        chartViewData.drawValuesEnabled = true
        
        chartViewData.fillAlpha = 1
        chartViewData.fill = Fill(linearGradient: getGradientChartViewBackground(), angle: 90)
        chartViewData.drawFilledEnabled = true
        
        chartViewData.valueTextColor = .white
        
        let setDataOnChart = LineChartData(dataSet: chartViewData)
        self.chartView.data = setDataOnChart
    }
    
    public var price: String? {
        get {
            return self.labelPrice.text
        }
        set {
            self.labelPrice.text = newValue
        }
    }
    
    public var percentage: String? {
        get {
            return self.labelPercentage.text
        }
        set {
            self.labelPercentage.text = newValue
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
