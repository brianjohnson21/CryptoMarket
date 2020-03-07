//
//  ChartContentTableViewCell.swift
//  CryptoMarket
//
//  Created by Thomas Martins on 07/02/2020.
//  Copyright © 2020 Thomas Martins. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChartContentTableViewCell: UITableViewCell {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewContainer: UIView!
    @IBOutlet private weak var container: UIView!
    
    private var viewModel: ContentChartViewModel! = nil
    private let disposeBag: DisposeBag = DisposeBag()
    private var scrollViewDataSource: [UIView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    //MARK: method called outisde to setup the view
    public func setup(data: String) {
        //self.ScrollViewPageControl.numberOfPages = 2
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.scrollView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupScrollViewOnSlides()

    }
    
    private func setupScrollViewOnSlides() {
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(self.scrollViewDataSource.count), height: 0)
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0 ..< self.scrollViewDataSource.count {
            self.scrollViewDataSource[i].frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
            self.scrollView.addSubview(self.scrollViewDataSource[i])
        }
    }
    
    //TMP
    private func generateChartsView() -> [UIView] {
        var diagram: [UIView] = []
        
        if let pieDiagram: PieChart = Bundle.main.loadNibNamed(PieChart.identifier, owner: nil, options: nil)?.first as? PieChart {
            pieDiagram.setup()
            print("[PIECHART][SIZE] = \(pieDiagram.frame.width)")
            diagram.append(pieDiagram)
        }
        
        if let lineChart: LineChart = Bundle.main.loadNibNamed(LineChart.identifier, owner: nil, options: nil)?.first as? LineChart {
            lineChart.setup()
            diagram.append(lineChart)
        }
        
        return diagram
    }
    
    //END TMP
    
    private func setupViewModel() {
        self.scrollViewDataSource = self.generateChartsView()
        self.scrollView.reloadInputViews()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension ChartContentTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(self.scrollView.contentOffset.x / self.frame.width)
    }
}
