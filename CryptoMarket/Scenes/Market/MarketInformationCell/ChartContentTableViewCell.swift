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
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!
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
    public func setup(lineChartName name: String, lineChartPercentage percentage: String) {        
        self.viewModel = ContentChartViewModel(lineChartName: name, lineChartPercentage: percentage)
        self.setupView()
        self.setupViewModel()
    }
    
    private func setupView() {
        self.scrollView.delegate = self
    }
    
    private func setupViewModel() {
        
        let outputViewModel = self.viewModel.transform(input: ContentChartViewModel.Input())
        
        outputViewModel.chartsView.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (scrollviewDataSource) in
                self.scrollViewDataSource = scrollviewDataSource
                self.pageControl.currentPage = 0
                self.pageControl.numberOfPages = self.scrollViewDataSource.count
                ///MARK: remove this
                self.scrollView.reloadInputViews()
                self.setupScrollViewOnSlides()
            }).disposed(by: self.disposeBag)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension ChartContentTableViewCell: UIScrollViewDelegate {
    
    private func setupScrollViewOnSlides() {
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.containerView.frame.height)
        self.scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(self.scrollViewDataSource.count), height: 0)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        for i in 0 ..< self.scrollViewDataSource.count {
            self.scrollViewDataSource[i].frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.containerView.frame.height)
            self.scrollView.addSubview(self.scrollViewDataSource[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(self.scrollView.contentOffset.x / self.frame.width)
        self.pageControl.currentPage = Int(pageIndex)
    }
}
