//
//  ChartTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 24/11/2019.
//  Copyright © 2019 Thomas Martins. All rights reserved.
//

import UIKit
import SwiftChart

class ChartTableViewCell: UITableViewCell {

    @IBOutlet private weak var chartTitle: UILabel!
    @IBOutlet private weak var detailTitle: UILabel!
    @IBOutlet private weak var chartView: Chart!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setupChart() {
        let data = [
          (x: 0, y: 0),
          (x: 3, y: 2.5),
          (x: 4, y: 2),
          (x: 5, y: 2.3),
          (x: 7, y: 3),
          (x: 8, y: 2.2),
          (x: 9, y: 2.5)
        ]
        let series = ChartSeries(data: data)
        series.area = true

        // Use `xLabels` to add more labels, even if empty
        chartView.xLabels = [0, 3, 6, 9, 12, 15, 18, 21, 24]

        // Format the labels with a unit
        chartView.xLabelsFormatter = { String(Int(round($1))) + "h" }

        chartView.add(series)
    }
    
    public var title: String? {
        get {
            return self.chartTitle.text
        }
        set {
            self.chartTitle.text = newValue
        }
    }
    
    public var detail: String? {
        get {
            return self.detailTitle.text
        }
        set {
            self.detailTitle.text = newValue
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
