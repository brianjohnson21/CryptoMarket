//
//  LineChart.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 22/02/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

final class LineChart: UIView {

    @IBOutlet private weak var lineChartView: LineChartView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var percentageLabel: UILabel!
    @IBOutlet private weak var percentageImage: UIImageView!
    @IBOutlet private weak var chartSpinner: UIActivityIndicatorView!
    
    private var viewModel: LineChartViewModel! = nil
    private let disposeBag: DisposeBag = DisposeBag()
    private let chartEventOnLegend: BehaviorSubject<LineChartViewModel.ChartLegend> = BehaviorSubject(value: .day)
    private var tagButtonSelected = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var price: String? {
        get {
            return self.priceLabel.text
        }
        set {
            self.priceLabel.text = newValue
        }
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
    
    private func setupView() {
        (self.viewWithTag(self.tagButtonSelected) as? UIButton)?.isSelected = true
        self.addHighlight(buttonTag: self.tagButtonSelected)
        self.setupSpinner(isLoading: true)
    }
    
    @IBAction private func legendTapped(_ sender: UIButton) {
        let oldSender = (self.viewWithTag(tagButtonSelected) as? UIButton)
           oldSender?.isSelected = false
           self.removeHighlight(buttonTag: self.tagButtonSelected)
           
           self.tagButtonSelected = sender.tag
           self.addHighlight(buttonTag: sender.tag)
           sender.isSelected = true
           
        self.chartEventOnLegend.onNext(LineChartViewModel.ChartLegend(rawValue: self.tagButtonSelected) ?? LineChartViewModel.ChartLegend.month)
    }
    
    //method called outside to setup
    public func setup(assetName: String, assetPercentage percentage: String, currencyPrice price: String) {
        self.viewModel = LineChartViewModel(chartId: assetName.lowercased(), globalPercentage: percentage)
        self.price = price
        self.setupView()
        self.setChartSettings()
        self.setPercentageOnChart(percentage: percentage)
        self.setupSpinner(isLoading: true)
        self.setupViewModel()
    }
    
    private func setChartSettings() {
        self.lineChartView.chartDescription?.enabled = false
        self.lineChartView.dragEnabled = false
        self.lineChartView.legend.enabled = false
           
        self.lineChartView.leftAxis.enabled = false
        self.lineChartView.rightAxis.enabled = false
        
        self.lineChartView.xAxis.enabled = false
        self.lineChartView.animate(xAxisDuration: 1)
        self.lineChartView.pinchZoomEnabled = false
    }
    
    private func setupSpinner(isLoading: Bool) {
        self.chartSpinner.isHidden = !isLoading
        isLoading ? self.chartSpinner.startAnimating() : self.chartSpinner.stopAnimating()
    }
    
    private func setupViewModel() {
        let input = LineChartViewModel.Input(legendEvent: self.chartEventOnLegend.asObservable())
        
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
        
        output.percentageColor.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (color) in
                self.percentageLabel.tintColor = color
            }).disposed(by: self.disposeBag)
            
    }
    
    private func setPercentageOnChart(percentage: String) {
        self.percentageLabel.text = "\(abs(Double(percentage) ?? 0))".percentageFormatting()
        let currentValue = Double(percentage) ?? 0
        self.percentageLabel.textColor = currentValue > 0 ? UIColor.init(named: "SortUp") : UIColor.init(named: "SortDown")
        self.percentageImage.image = currentValue > 0 ? UIImage(named: "sort-up-solid") : UIImage(named: "sort-down-solid")
    }
    
    private func setupChartViewData(chartData: [ChartDataEntry]) {
        let chartViewData = LineChartDataSet(entries: chartData, label: "YES")
        chartViewData.drawIconsEnabled = false
        
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
        
        self.lineChartView.data = setDataOnChart
        self.lineChartView.animate(xAxisDuration: 0.2)
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
