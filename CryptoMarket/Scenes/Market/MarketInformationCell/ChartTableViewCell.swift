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

class ChartTableViewCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet private weak var labelPrice: UILabel!
    @IBOutlet private weak var labelPercentage: UILabel!
    @IBOutlet private weak var imageSort: UIImageView!
    @IBOutlet private weak var chartSpinner: UIActivityIndicatorView!
    
    private let viewModel: MarketChartViewModel = MarketChartViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let chartLegendEvent: PublishSubject<chartLegendType> = PublishSubject()
    private var tagButtonSelected = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        (self.viewWithTag(self.tagButtonSelected) as? UIButton)?.isSelected = true
        self.addHighlight(buttonTag: self.tagButtonSelected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupSpinner() {
        self.chartSpinner.startAnimating()
    }
    
    private func setupViewModel() {
        let input = MarketChartViewModel.Input(legendEvent: self.chartLegendEvent.asObservable())
        
        let output = self.viewModel.transform(input: input)

        output.isChartLoading.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .debug()
            .subscribe(onNext: { (isLoading) in

                self.chartSpinner.isHidden = !isLoading
                isLoading ? self.chartSpinner.startAnimating() : self.chartSpinner.stopAnimating()
                
            }).disposed(by: self.disposeBag)
        
         self.setupChartViewData(chartData: output.chartData)
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
        self.chartLegendEvent.onNext(chartLegendType(rawValue: self.tagButtonSelected) ?? chartLegendType.d1)
    }
    
    public func setupChart() {

        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.legend.enabled = false
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.enabled = false
        chartView.animate(xAxisDuration: 1)
        
        self.setupSpinner()
        self.setupViewModel()
    }
    
    
    private func getGradientChartViewBackground() -> CGGradient {
        let gradientColors = [UIColor.init(named: "Color-3")?.cgColor, UIColor.init(named: "Color")?.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        return gradient
    }
    
    private func setupChartViewData(chartData: [ChartDataEntry]) {
        let chartViewData = LineChartDataSet(entries: chartData, label: "")
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
