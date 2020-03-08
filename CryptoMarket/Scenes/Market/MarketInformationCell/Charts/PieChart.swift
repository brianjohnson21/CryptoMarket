//
//  PieChart.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 22/02/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

final class PieChart: UIView {
    
    @IBOutlet private weak var pieChartView: PieChartView!
    
    private var viewModel: PieChartViewModel! = nil
    private let disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //method called outside to setup
    public func setup() {
        print("[A]")
        self.viewModel = PieChartViewModel()
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        print("[B]")
        self.testSetupView()
    }
    
    private func setupViewModel() {
        let input = PieChartViewModel.Input()
        
        let output = self.viewModel.transform(input: input)
        
        print(output)
    }
    
    private func testSetupView() {
        print("[C]")
        //self.pieChartView.delegate = self
        
        self.pieChartView.holeColor = UIColor.init(named: "MainColor") ?? UIColor.red
        //self.pieChartView.transparentCircleColor = NSUIColor.white.withAlphaComponent(0.43)
        self.pieChartView.holeRadiusPercent = 0.58
        self.pieChartView.rotationEnabled = false
        self.pieChartView.highlightPerTapEnabled = true
        
        self.pieChartView.maxAngle = 180 // Half chart
        self.pieChartView.rotationAngle = 180 // Rotate to make the half on the upper side
        self.pieChartView.centerTextOffset = CGPoint(x: 0, y: -20)

        self.pieChartView.extraBottomOffset = -350
        self.pieChartView.extraTopOffset = 150
        self.pieChartView.extraLeftOffset = -60
        self.pieChartView.extraRightOffset = -60
        
        //self.pieChartView.legend.enabled = false
        //self.pieChartView.chartDescription?.enabled = false
        self.pieChartView.chartDescription?.text = "YOLO"
   
        //        chartView.legend = l
        // entry label styling
        let l = self.pieChartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
         l.drawInside = false
         l.xEntrySpace = 7
         l.yEntrySpace = 0
         l.yOffset = 0
        self.pieChartView.entryLabelColor = .white
        self.pieChartView.entryLabelFont = UIFont(name:"HelveticaNeue-Light", size:12)!
        
        self.pieChartView.backgroundColor = UIColor.init(named: "MainColor")
        
        
        self.testSetup()
        
        self.pieChartView.animate(xAxisDuration: 2.5, easingOption: .easeOutBack)
    }
    
    private func testSetup() {
        print("[D]")
        var pieDataEntry: [PieChartDataEntry] = [PieChartDataEntry]()
        for i in 0...5 {
            pieDataEntry.append(PieChartDataEntry(value: Double((i * 10)), label: "\(i)"))
        }
        
        print("INIDE -> \(pieDataEntry)")
        
        let set = PieChartDataSet(entries: pieDataEntry, label: "Election Results")
        set.sliceSpace = 3
        set.selectionShift = 5
        set.colors = ChartColorTemplates.material()
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11)!)
        data.setValueTextColor(.white)
        
        self.pieChartView.data = data
        
        self.pieChartView.setNeedsDisplay()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
