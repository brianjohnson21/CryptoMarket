//
//  LineChartFear.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 17/03/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

final class LineChartFear: UIView {
    
    @IBOutlet private weak var lineChart: LineChartView!
    @IBOutlet private weak var spinnerView: UIActivityIndicatorView!
    
    private var viewModel: LineChartEmotionsViewModel! = nil
    private let disposeBag: DisposeBag = DisposeBag()
    private let chartEventOnLegend: BehaviorSubject<LineChartEmotionsViewModel.ChartLegend> = BehaviorSubject(value: .week)
    
    private var tagButtonSelected = LineChartEmotionsViewModel.ChartLegend.week.rawValue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
    
    private func setupSpinner(isLoading: Bool) {
        self.spinnerView.isHidden = !isLoading
        isLoading ? self.spinnerView.startAnimating() : self.spinnerView.stopAnimating()
    }
 
    @IBAction private func legendEventTrigger(_ sender: UIButton) {
        let oldSender = (self.viewWithTag(tagButtonSelected) as? UIButton)
           oldSender?.isSelected = false
           self.removeHighlight(buttonTag: self.tagButtonSelected)
           self.tagButtonSelected = sender.tag
           self.addHighlight(buttonTag: sender.tag)
           sender.isSelected = true
         self.chartEventOnLegend.onNext(LineChartEmotionsViewModel.ChartLegend(rawValue: self.tagButtonSelected) ?? LineChartEmotionsViewModel.ChartLegend.week)
    }
    
    //method called outside to setup
    public func setup() {
        self.viewModel = LineChartEmotionsViewModel()
        
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.setChartSettings()
        (self.viewWithTag(self.tagButtonSelected) as? UIButton)?.isSelected = true
        self.addHighlight(buttonTag: self.tagButtonSelected)
        self.setupSpinner(isLoading: true)
    }
    
    private func setupViewModel() {
        
        let input = LineChartEmotionsViewModel.Input(legendEvent: self.chartEventOnLegend.asObservable())
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
        chartViewData.drawValuesEnabled = true
        chartViewData.drawFilledEnabled = false
        
        chartViewData.fillAlpha = 1
        chartViewData.fill = Fill(linearGradient: getGradientChartViewBackground(), angle: 90)
        chartViewData.drawFilledEnabled = true
        
        chartViewData.valueTextColor = .white
        
        let setDataOnChart = LineChartData(dataSet: chartViewData)
        
        if chartData.count > 30 {
            chartViewData.circleRadius = 0.2
        }
        
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
