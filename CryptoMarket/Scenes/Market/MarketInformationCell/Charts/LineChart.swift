//
//  LineChart.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 22/02/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import Charts

final class LineChart: UIView {

    @IBOutlet private weak var lineChartView: LineChartView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var percentageLabel: UILabel!
    @IBOutlet private weak var percentageImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //method called outside to setup
    public func setup() {
        self.setupViewModel()
    }
    
    private func setupViewModel() { }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
