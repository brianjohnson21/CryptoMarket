//
//  ChartTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 24/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import SwiftChart
import RxSwift
import RxCocoa
import Foundation
import Charts

internal enum ChartLegend : Int {
    case day = 1
    case week
    case month
    case year
    case all
}

class ChartTableViewCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet private weak var labelPrice: UILabel!
    @IBOutlet private weak var labelPercentage: UILabel!
    @IBOutlet private weak var imageSort: UIImageView!
    @IBOutlet private weak var chartSpinner: UIActivityIndicatorView!
    
    private var viewModel: MarketChartViewModel! = nil
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let chartEventOnLegend: BehaviorSubject<ChartLegend> = BehaviorSubject(value: .day)
    private var tagButtonSelected = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        (self.viewWithTag(self.tagButtonSelected) as? UIButton)?.isSelected = true
        self.addHighlight(buttonTag: self.tagButtonSelected)
        self.setupSpinner(isLoading: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupSpinner(isLoading: Bool) {
        self.chartSpinner.isHidden = !isLoading
        isLoading ? self.chartSpinner.startAnimating() : self.chartSpinner.stopAnimating()
    }
    
    private func setupViewModel() {
        let input = MarketChartViewModel.Input(legendEvent: self.chartEventOnLegend.asObservable())
        
        let output = self.viewModel.transform(input: input)

        output.chartViewData.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (chartData) in
                self.setupChartViewData(chartData: chartData)
            }).disposed(by: self.disposeBag)
            
        output.isChartLoading.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (isLoading) in
                self.setupSpinner(isLoading: isLoading)
            }).disposed(by: self.disposeBag)
        
        output.percentageChart.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (percentage) in
                self.setPercentageOnChart(percentage: percentage)
            }).disposed(by: self.disposeBag)
        
//        output.percentageColor.asObservable()
//            .observeOn(MainScheduler.instance)
//            .subscribeOn(MainScheduler.asyncInstance)
//            .subscribe(onNext: { (color) in
//                self.labelPercentage.textColor = color
//            }).disposed(by: self.disposeBag)
        
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
        
        self.chartEventOnLegend.onNext(ChartLegend(rawValue: self.tagButtonSelected) ?? ChartLegend.month)
    }
    
    private func setChartSettings() {
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.legend.enabled = false
           
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.enabled = false
        chartView.animate(xAxisDuration: 1)
        chartView.pinchZoomEnabled = false
    }
    
    ///Method called outside to setup the view
    public func setupChart(assetName: String, assetPercentage percentage: String) {

        self.viewModel = MarketChartViewModel(chartId: assetName.lowercased(),
                                              globalPercentage: percentage)
        
        self.setChartSettings()
        self.setPercentageOnChart(percentage: percentage)
        self.setupSpinner(isLoading: true)
        self.setupViewModel()
    }
    
    
    private func getGradientChartViewBackground() -> CGGradient {
        let gradientColors = [UIColor.init(named: "Color-3")?.cgColor, UIColor.init(named: "Color")?.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        return gradient
    }
    
    private func setupChartViewData(chartData: [ChartDataEntry]) {
        let chartViewData = LineChartDataSet(entries: chartData, label: "YES")
        chartViewData.drawIconsEnabled = false
        
        //chartViewData.setColor(UIColor.init(named: "Color-1") ?? .red)
        chartViewData.setColor(UIColor.init(named: "White") ?? .red)
        chartViewData.lineWidth = 1.0
        chartViewData.circleRadius = 0.0
        chartViewData.drawValuesEnabled = true
        chartViewData.drawFilledEnabled = false
        
        chartViewData.fillAlpha = 1
        chartViewData.fill = Fill(linearGradient: getGradientChartViewBackground(), angle: 90)
        chartViewData.drawFilledEnabled = true
        
        chartViewData.valueTextColor = .white
        
        let setDataOnChart = LineChartData(dataSet: chartViewData)
        
        self.chartView.data = setDataOnChart
        chartView.animate(xAxisDuration: 0.2)
    }
    
    private func setPercentageOnChart(percentage: String) {
        self.labelPercentage.text = "\(abs(Double(percentage) ?? 0))".percentageFormatting()
        let currentValue = Double(percentage) ?? 0
        self.labelPercentage.textColor = currentValue > 0 ? UIColor.init(named: "SortUp") : UIColor.init(named: "SortDown")
        self.imageSort.image = currentValue > 0 ? UIImage(named: "sort-up-solid") : UIImage(named: "sort-down-solid")
    }
    
    public var price: String? {
        get {
            return self.labelPrice.text
        }
        set {
            self.labelPrice.text = newValue
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
